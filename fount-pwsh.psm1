. $PSScriptRoot/base.ps1
. $PSScriptRoot/predicate.ps1
. $PSScriptRoot/assists/main.ps1

Export-ModuleMember -Function @(
	"Set-FountAssist",
	"Install-FountAssist",
	"Set-FountClient",
	"Close-FountClient",
	"Test-FountRunning",
	"Invoke-FountIPC",
	"Start-FountShell",
	"Invoke-FountShell",
	"Start-Fount",
	"Stop-Fount",
	"Install-Fount"
) -Variable @(
	"FountAssist"
)
