$Global:FountAssist = @{
	Enabled                  = $true
	AssistCharname           = $null
	FountUsername            = $null
	shellhistory             = [System.Collections.ArrayList]@()
	rejected_commands        = [System.Collections.ArrayList]@()
	chat_scoped_char_memorys = @{}
	# 以非0返回值指示信息而非错误的命令
	NonZeroReturnWhiteList   = [System.Collections.ArrayList]@('robocopy')
}

$script:FountAssistInstalled = $false

function Set-FountAssist(
	[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$(Get-FountUserList).Where({ $_.StartsWith($WordToComplete) })
		})]
	$FountUsername,
	[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$FountUsername = $fakeBoundParameters.FountUsername
			$(Get-FountPartList -Username $FountUsername -parttype chars).Where({ $_.StartsWith($WordToComplete) })
		})]
	$AssistCharname
) {
	if ($AssistCharname) { $Global:FountAssist.AssistCharname = $AssistCharname }
	if ($FountUsername) { $Global:FountAssist.FountUsername = $FountUsername }
	if (!(Test-FountRunning)) {
		Start-Fount background keepalive runshell $Global:FountAssist.FountUsername preload chars $Global:FountAssist.AssistCharname
	}
	if ($script:FountAssistInstalled) { return }
	if ($EshellUI) { . $PSScriptRoot/esh-assist.ps1 }
	else { . $PSScriptRoot/pwsh-assist.ps1 }
	$script:FountAssistInstalled = $true
}

function Install-FountAssist(
	[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$(Get-FountUserList).Where({ $_.StartsWith($WordToComplete) })
		})]
	$FountUsername,
	[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$FountUsername = $fakeBoundParameters.FountUsername
			$(Get-FountPartList -Username $FountUsername -parttype chars).Where({ $_.StartsWith($WordToComplete) })
		})]
	$AssistCharname
) {
	if ($AssistCharname) { $Global:FountAssist.AssistCharname = $AssistCharname }
	if ($FountUsername) { $Global:FountAssist.FountUsername = $FountUsername }
	if ($EshellUI) {
		$EshellUI.FountAssist = "$($Global:FountAssist.FountUsername):$($Global:FountAssist.AssistCharname)"
	}
	else {
		$content = Get-Content $PROFILE -ErrorAction Ignore
		$content = $content -split "`n" | Where-Object { $_ -notmatch 'Set-FountAssist' }
		$content += "Set-FountAssist $($Global:FountAssist.FountUsername) $($Global:FountAssist.AssistCharname)"
		$content = $content -join "`n"
		Set-Content $PROFILE $content
	}
	Set-FountAssist
}
