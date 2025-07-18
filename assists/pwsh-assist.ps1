﻿function Script:Get-ScreenBufferAsText {
    $stringBuilder = [System.Text.StringBuilder]::new()
    $rawUI = $Host.UI.RawUI
    $captureWidth = $rawUI.BufferSize.Width
    $captureHeight = $rawUI.CursorPosition.Y
    if ($captureHeight -le 0) { return "" }
    $rectangle = [System.Management.Automation.Host.Rectangle]::new(0, 0, $captureWidth, $captureHeight)
    $buffer = $rawUI.GetBufferContents($rectangle)
    for ($y = 0; $y -lt $captureHeight; $y++) {
        $lineContent = ""
        for ($x = 0; $x -lt $captureWidth; $x++) {
            $lineContent += $buffer[$y, $x].Character
        }
        $stringBuilder.AppendLine($lineContent.TrimEnd()) | Out-Null
    }
    return $stringBuilder.ToString().TrimEnd() -replace "`0", ""
}
$PSDefaultParameterValues['Out-Default:OutVariable'] = 'fount_ans_capture_array'
function global:f(
	[ValidateScript({
		(IsEnable $_) -or (IsDisable $_) -or (!$_)
	})]
	$switch,
	$CommandErrors
) {
	if ($switch -ne $null) {
		$Global:FountAssist.Enabled = IsEnable $switch
		Write-Host "fount assist is $(@('disabled','enabled')[$Global:FountAssist.Enabled])"
		return
	}
	if (!$CommandErrors) {
		$CommandErrors = $Error | Select-Object -SkipLast $Global:FountAssist.HistoryErrorCount
	}
	$requst = @{
		charname                 = $Global:FountAssist.AssistCharname
		UserCharname             = $Global:FountAssist.UserCharname
		shelltype                = "powershell"
		shellhistory             = $Global:FountAssist.shellhistory
		command_now              = $Global:FountAssist.last_commaned.command
		command_output           = $fount_ans_capture | Out-String -Width 65536
		command_error            = $CommandErrors | Out-String -Width 65536
		rejected_commands        = $Global:FountAssist.rejected_commands
		chat_scoped_char_memorys = $Global:FountAssist.chat_scoped_char_memorys
		pwd                      = "$pwd"
		screen                   = Get-ScreenBufferAsText
	}
	$result = Invoke-FountPart shells $Global:FountAssist.FountUsername 'shellassist' $requst
	if ($result.chat_scoped_char_memorys) {
		$Global:FountAssist.chat_scoped_char_memorys = $result.chat_scoped_char_memorys
	}
	if ($result.shellhistory) {
		$Global:FountAssist.shellhistory = [System.Collections.ArrayList]$result.shellhistory
	}

	if ($result.content -or $result.recommend_command) {
		Write-Host
	}
	if ($Global:FountAssist.last_commaned) {
		$Global:FountAssist.last_commaned.output = $fount_ans_capture | Out-String -Width 65536
		$Global:FountAssist.last_commaned.error = $requst.command_error
		$Global:FountAssist.shellhistory.Add($Global:FountAssist.last_commaned) | Out-Null
		$Global:FountAssist.last_commaned = $null
	}
	if ($result.content) {
		$Global:FountAssist.shellhistory.Add(@{
			name      = $result.name
			avatar    = $result.avatar
			role      = "char"
			content   = $result.content
			extension = $result.extension
		}) | Out-Null
		Write-Host $result.content
	}
	if ($result.recommend_command) {
		# 显示并询问是否执行或重新推荐
		Write-Host "use `"" -NoNewline
		Write-Host $result.recommend_command -ForegroundColor Yellow -NoNewline
		Write-Host "`" as command? " -NoNewline
		Write-Host "[" -NoNewline
		Write-Host "enter" -ForegroundColor Green -NoNewline
		Write-Host "/" -NoNewline
		Write-Host "n" -ForegroundColor Blue -NoNewline
		Write-Host " (next)/" -NoNewline
		Write-Host "ctrl+c" -ForegroundColor Red -NoNewline
		Write-Host "]"
		[console]::TreatControlCAsInput = $true
		while ($true) {
			Start-Sleep -Milliseconds 100
			if ([console]::KeyAvailable) {
				$key = [console]::ReadKey($true)
				if ($key.Key -eq "Enter") {
					[console]::TreatControlCAsInput = $false
					[Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($result.recommend_command)
					$StartExecutionTime = Get-Date
					$(Invoke-Expression $result.recommend_command | Out-Default) *>&1 | Out-Host
					$EndExecutionTime = Get-Date
					[PSCustomObject](@{
						CommandLine        = $result.recommend_command
						ExecutionStatus    = "Completed"
						StartExecutionTime = $StartExecutionTime
						EndExecutionTime   = $EndExecutionTime
					}) | Add-History
					return
				}
				if ($key.Key -eq "N") {
					$Global:FountAssist.rejected_commands.Add($result.recommend_command) | Out-Null
					f
					return
				}
				if ($key.Key -eq "C" -and $key.Modifiers -eq "Control") {
					[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
					return
				}
			}
		}
	}
}
$Global:FountAssist.HistoryErrorCount = $Error.Count
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	$global:fount_ans_capture = $($global:fount_ans_capture_array)
	$global:fount_ans_capture_array = [System.Collections.ArrayList]@()

	if ($Global:FountAssist.last_commaned) {
		$Global:FountAssist.last_commaned.output = $fount_ans_capture | Out-String -Width 65536
		$Global:FountAssist.last_commaned.error = $Error | Select-Object -SkipLast $Global:FountAssist.HistoryErrorCount | Out-String -Width 65536
		$Global:FountAssist.shellhistory.Add($Global:FountAssist.last_commaned) | Out-Null
	}

	$Global:FountAssist.last_commaned = @{
		command = $line
		time    = Get-Date
	}

	# keep shellhistory's last 30 records
	while ($Global:FountAssist.shellhistory.Count -gt 30) {
		$Global:FountAssist.shellhistory.RemoveAt(0)
	}
	$Global:FountAssist.rejected_commands = [System.Collections.ArrayList]@()
	$Global:FountAssist.HistoryErrorCount = $Error.Count

	if (!$Global:FountAssist.Enabled) {
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
		return
	}

	$parseError = $null
	$ast = [System.Management.Automation.Language.Parser]::ParseInput($line, [ref]$null, [ref]$parseError)

	$bad_expr = $false
	if ($parseError) { return f -CommandErrors $parseError }
	$Errors = @()
	$Commands = $ast.FindAll({param($ast) $ast -is [System.Management.Automation.Language.CommandAst] }, $true)
	foreach ($Command in $Commands) {
		$null = try {
			Get-Command $Command.CommandElements[0]
		}
		catch {
			$bad_expr = $true
			$Errors.Add($_) | Out-Null
		}
	}

	#若当前表达式是合法ps脚本但不是合法命令
	if ($bad_expr -and !$PSDebugContext) {
		f -CommandError $Errors
		$YIndexBackup = $host.UI.RawUI.CursorPosition.Y
		[Microsoft.PowerShell.PSConsoleReadLine]::CancelLine()
		Write-Host "`b`b  " -NoNewline
		try {
			if ($host.UI.RawUI.CursorPosition.Y -ne $YIndexBackup) {
				$host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates 0, $YIndexBackup
			}
		} catch { }
		Write-Host
	}
	else {
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
	}
}
if (-not $Global:FountAssist.OriginalPrompt) {
	$Global:FountAssist.OriginalPrompt = Get-Content function:\prompt
}
function global:prompt {
	if (-not $PSDebugContext -and -not $? -and $Global:FountAssist.NonZeroReturnWhiteList -notcontains (($expr_now -split '\s')[0])) {
		if ($Global:FountAssist.Enabled) {
			try { f -CommandErrors '$? not true' } catch {}
		}
	}
	& $Global:FountAssist.OriginalPrompt
}
