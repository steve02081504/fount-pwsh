. $PSScriptRoot/base.ps1
. $PSScriptRoot/predicate.ps1
. $PSScriptRoot/assists/main.ps1

Export-ModuleMember -Function @(
	"Set-FountAssist",
	"Install-FountAssist",
	"Get-FountClient",
	"Invoke-FountIPC",
	"Start-FountShell",
	"Invoke-FountShell",
	"Start-Fount",
	"Stop-Fount",
	"Install-Fount"
) -Variable @(
	"FountAssist"
)
