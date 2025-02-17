# 获取 Fount 工具的根目录。
function Get-FountDirectory {
	# Get-Command fount.ps1 获取 fount.ps1 脚本的信息。
	# .Path 获取脚本的完整路径。
	# Split-Path -Parent 两次，获取脚本所在目录的父目录，即 Fount 工具的根目录。
    (Get-Command fount.ps1).Path | Split-Path -Parent | Split-Path -Parent
}

# 获取所有 Fount 用户的用户名列表。
function Get-FountUserList {
	# $(Get-FountDirectory)/data/users 构造用户数据目录的路径。
	# Get-ChildItem -Directory 获取该目录下的所有子目录（即用户名）。
	# ForEach-Object Name 提取每个子目录的名称（即用户名）。
	Get-ChildItem -Path "$(Get-FountDirectory)/data/users" -Directory | ForEach-Object Name
}

function Get-FountParts {
	@(
		'shells', 'chars', 'personas', 'worlds', 'AIsources', 'AIsourceGenerators', 'ImportHanlders'
	)
}

function Get-FountPartList {
	param([string]$parttype, [string]$Username)
	$fountDir = Get-FountDirectory
	$isFile = $parttype -eq 'AIsources'
	# 如果提供了用户名：
	$userParts = if ($Username) {
		Get-ChildItem -Path "$fountDir/data/users/$Username/$parttype" -Directory:$(!$isFile) -File:$isFile -ErrorAction SilentlyContinue
	}
	$publicParts = Get-ChildItem -Path "$fountDir/src/public/$parttype" -Directory:$(!$isFile) -File:$isFile -ErrorAction SilentlyContinue
	.{ $userParts; $publicParts } | Where-Object {
		if ($isFile) { $_ }
		else {
			Test-Path $(Join-Path -Path $_.FullName -ChildPath "main.mjs") -PathType Leaf
		}
	} | ForEach-Object {
		if($isFile) { $_.BaseName }
		else { $_.Name }
	} | Sort-Object -Unique
}

function Get-FountPartDirectory {
	param([string]$Username, [string]$parttype, [string]$partname)
	$fountDir = Get-FountDirectory
	$isFile = $parttype -eq 'AIsources'
	# 构造用户特定的 Shell 目录路径。
	$userPath = "$fountDir/data/users/$Username/$parttype/$partname"
	# 构造公共 Shell 目录路径。
	$publicPath = "$fountDir/src/public/$parttype/$partname"
	# 优先返回用户特定的 Shell 目录路径（如果存在）。
	if ($isFile) {
		function Test-PartExist($path) {
			Test-Path $path -PathType Leaf
		}
	}
	else {
		function Test-PartExist($path) {
			Test-Path "$path/main.mjs" -PathType Leaf
		}
	}
	if (Test-PartExist $userPath) {
		$userPath
	}
	elseif (Test-PartExist $publicPath) {
		$publicPath
	}
}
