$EshellUI.ExecutionRecorders.Add({
	if ($Global:FountAssist.last_commaned) {
		$Global:FountAssist.last_commaned.output = $ans | Out-String -Width 65536
		$Global:FountAssist.last_commaned.error = $err | Out-String -Width 65536
		$Global:FountAssist.shellhistory.Add($Global:FountAssist.last_commaned) | Out-Null
	}
	$Global:FountAssist.last_commaned = @{
		command = $expr_now
		time    = Get-Date
	}
	# keep shellhistory's last 30 records
	while ($Global:FountAssist.shellhistory.Count -gt 30) {
		$Global:FountAssist.shellhistory.RemoveAt(0)
	}
	$Global:FountAssist.rejected_commands = [System.Collections.ArrayList]@()
}) | Out-Null
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
		$CommandErrors = $global:expr_err_now
	}
	$requst = @{
		charname                 = $Global:FountAssist.AssistCharname
		UserCharname             = $Global:FountAssist.UserCharname
		shelltype                = "esh(like powershell)"
		shellhistory             = $Global:FountAssist.shellhistory
		command_now              = $expr_now
		command_output           = $ans | Out-String -Width 65536
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
		$Global:FountAssist.last_commaned.output = $ans | Out-String -Width 65536
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
					$EshellUI.AcceptLine($result.recommend_command)
					return
				}
				if ($key.Key -eq "N") {
					$Global:FountAssist.rejected_commands.Add($result.recommend_command) | Out-Null
					return f
				}
				if ($key.Key -eq "C" -and $key.Modifiers -eq "Control") {
					$EshellUI.CancelLine()
					return
				}
			}
		}
	}
}
$EshellUI.ExecutionHandlers.Add({
	if (!$Global:FountAssist.Enabled) {
		return
	}
	if ($global:bad_expr_now) {
		f -CommandErrors $global:expr_err_now
		$Global:FountAssist.Triggered = $true
		return '' #终止当前表达式
	}
}) | Out-Null
$EshellUI.AfterExecutionHandlers.Add({
	if ($Global:FountAssist.Triggered -or !$Global:FountAssist.Enabled) {
		$Global:FountAssist.Triggered = $false
		return
	}
	#若当前表达式退出值不为0且不在白名单中
	if (-not $? -and $Global:FountAssist.NonZeroReturnWhiteList -notcontains (($expr_now -split '\s')[0])) {
		f -CommandErrors '$? not true'
	}
}) | Out-Null
