﻿. $PSScriptRoot/base.ps1
. $PSScriptRoot/predicate.ps1
. $PSScriptRoot/assists/main.ps1
. $PSScriptRoot/data.ps1
. $PSScriptRoot/argument_completer.ps1

Export-ModuleMember -Function @(
	"Set-FountAssist"
	"Install-FountAssist"

	"Set-FountClient"
	"Close-FountClient"
	"Test-FountRunning"
	"Invoke-FountIPC"
	"Start-FountPart"
	"Invoke-FountPart"

	"Start-Fount"
	"Stop-Fount"
	"Install-Fount"

	"Get-FountDirectory"
	"Get-FountUserList"
	"Get-FountPartTypeList"
	"Get-FountPartList"
	"Get-FountPartDirectory"
) -Variable @(
	"FountAssist"
)
