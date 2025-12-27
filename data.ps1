# 获取 fount 工具的根目录。
function Get-FountDirectory {
	# Get-Command fount.ps1 获取 fount.ps1 脚本的信息。
	# .Path 获取脚本的完整路径。
	# Split-Path -Parent 两次，获取脚本所在目录的父目录，即 fount 工具的根目录。
    (Get-Command fount.ps1).Path | Split-Path -Parent | Split-Path -Parent
}

# 获取所有 fount 用户的用户名列表。
function Get-FountUserList {
	# $(Get-FountDirectory)/data/users 构造用户数据目录的路径。
	# Get-ChildItem -Directory 获取该目录下的所有子目录（即用户名）。
	# ForEach-Object Name 提取每个子目录的名称（即用户名）。
	Get-ChildItem -Path "$(Get-FountDirectory)/data/users" -Directory | ForEach-Object Name
}

function Get-FountPartList {
	param(
		[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$(Get-FountUserList).Where({ $_.StartsWith($WordToComplete) })
		})]
		[string]$Username,
		[string]$PartPath = ''
	)
	$fountDir = Get-FountDirectory

	# 构建搜索路径
	# 如果是顶级目录（PartPath 为空），扫描 parts 目录获取顶级类型
	if ([string]::IsNullOrEmpty($PartPath)) {
		$userPartDir = if ($Username) { "$fountDir/data/users/$Username" } else { $null }
		$publicPartDir = "$fountDir/src/public/parts"
	}
	else {
		$userPartDir = if ($Username) { "$fountDir/data/users/$Username/$PartPath" } else { $null }
		$publicPartDir = "$fountDir/src/public/parts/$PartPath"
	}

	$partlist = @()

	# 扫描用户目录
	if ($userPartDir -and (Test-Path $userPartDir -PathType Container)) {
		$userParts = Get-ChildItem -Path $userPartDir -Directory -ErrorAction SilentlyContinue
		$partlist += $userParts
	}

	# 扫描公共目录
	if (Test-Path $publicPartDir -PathType Container) {
		$publicParts = Get-ChildItem -Path $publicPartDir -Directory -ErrorAction SilentlyContinue
		$currentNames = New-Object System.Collections.Generic.HashSet[string]
		$partlist | ForEach-Object { $currentNames.Add($_.Name) | Out-Null }
		$publicParts | Where-Object { -not $currentNames.Contains($_.Name) } | ForEach-Object { $partlist += $_ }
	}

	# 过滤并返回结果（检查 fount.json）
	$partlist | Where-Object {
		Test-Path $(Join-Path -Path $_.FullName -ChildPath "fount.json") -PathType Leaf
	} | ForEach-Object {
		$_.Name
	} | Sort-Object -Unique
}

function Get-FountPartDirectory {
	param(
		[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$(Get-FountUserList).Where({ $_.StartsWith($WordToComplete) })
		})]
		[string]$Username,
		[ArgumentCompleter({
			param ( $commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters )
			$username = $fakeBoundParameters['Username']
			$parts = ("/$wordToComplete" -split '/', 2)[1] -split '/', 2
			$parttype = $parts[0] -replace '^/', ''
			$partnamePrefix = if ($parts.Count -gt 1) { $parts[1] } else { '' }
			$partList = Get-FountPartList -Username $username -PartPath $parttype | Where-Object { $_.StartsWith($partnamePrefix) }
			$partList | ForEach-Object {
				$fullPath = ("$parttype/$_" -replace '^/', '')
				[System.Management.Automation.CompletionResult]::new($fullPath, $_, 'ParameterValue', $fullPath)
			}
		})]
		[Parameter(Mandatory)]
		[string]$PartPath
	)
	$fountDir = Get-FountDirectory
	# 构造用户特定的 Part 目录路径。
	$userPath = "$fountDir/data/users/$Username/$PartPath"
	# 构造公共 Part 目录路径。
	$publicPath = "$fountDir/src/public/parts/$PartPath"
	# 优先返回用户特定的 Part 目录路径（如果存在，检查 fount.json）。
	if (Test-Path "$userPath/fount.json" -PathType Leaf) {
		$userPath
	}
	elseif (Test-Path "$publicPath/fount.json" -PathType Leaf) {
		$publicPath
	}
}
