# pwsh ./.github/workflows/publish.ps1 -version ${{ github.ref_name }} -ApiKey ${{ secrets.NUGET_API_KEY }}

[CmdletBinding()]
param(
	[Parameter(Mandatory = $true)]
	[string]$version,
	[Parameter(Mandatory = $true)]
	[string]$ApiKey
)
if ($version -match '^v(\d+\.\d+\.\d+)$') {
	$version = $Matches[1]
}
else {
	throw "invalid version: $version"
}

$repoPath = "$PSScriptRoot/../.."
. $PSScriptRoot/PSObjectToString.ps1
$error.clear()

try {
	# read psd1
	$packData = Import-PowerShellDataFile "$repoPath/fount-pwsh.psd1"
	# update version
	$packData.ModuleVersion = $version
	# update psd1
	Set-Content -Path "$repoPath/fount-pwsh.psd1" -Value $(PSObjectToString($packData)) -NoNewline -Encoding UTF8 -Force
	# 遍历文件列表，移除.开头的文件和文件夹
	Get-ChildItem -Path $repoPath -Recurse | Where-Object { $_.Name -match '^\.' } | ForEach-Object { Remove-Item -Path $_.FullName -Force -Recurse }
	# 打包发布
	Install-Module -Name 'PowerShellGet' -Force -Scope CurrentUser | Out-Null
	$errnum = $Error.Count
	Publish-Module -Path $repoPath -NuGetApiKey $ApiKey -ErrorAction Stop
	while ($Error.Count -gt $errnum) {
		$Error.RemoveAt(0)
	}
}
catch {}

if ($error) {
	Write-Output "::group::PSVersion"
	Write-Output $PSVersionTable
	Write-Output "::endgroup::"

	$error | ForEach-Object {
		Write-Output "::error file=$($_.InvocationInfo.ScriptName),line=$($_.InvocationInfo.ScriptLineNumber),col=$($_.InvocationInfo.OffsetInLine),endColumn=$($_.InvocationInfo.OffsetInLine),tittle=error::$_"
		Write-Output "::group::script stack trace"
		Write-Output $_.ScriptStackTrace
		Write-Output "::endgroup::"
		Write-Output "::group::error details"
		Write-Output $_
		Write-Output "::endgroup::"
	}
	exit 1
}

Write-Output "Nice CI!"
