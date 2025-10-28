# 获取具有补全脚本的 Part 列表。
function Get-FountPartListWithCompleter {
	param([string]$Username, [string]$parttype)
	# 获取指定用户或所有用户的可用 Shell 列表。
	Get-FountPartList -parttype $parttype -Username $Username |
	# 筛选出存在 argument_completer.ps1 脚本的 Shell。
	Where-Object {
		$shellDir = Get-FountPartDirectory -Username $Username -parttype $parttype -partname $_
		Test-Path (Join-Path -Path $shellDir -ChildPath "argument_completer.ps1") -PathType Leaf
	}
}

# 移除哈希表中的指定键及其子键（递归）。
function Remove-ArgumentNode {
	param([hashtable]$Node, [string]$Key)
	# 如果哈希表中存在指定的键，则移除该键。
	if ($Node.ContainsKey($Key)) { $Node.Remove($Key) }
	# 遍历哈希表中的所有键。
	foreach ($mapperkey in $Node.Keys) {
		# 如果当前键对应的值是哈希表，则递归调用 Remove-ArgumentNode 函数。
		if ($Node[$mapperkey] -is [hashtable]) { Remove-ArgumentNode -Node $Node[$mapperkey] -Key $Key }
	}
}

# 处理 'run' 子命令的参数补全。
function Invoke-RunshellCompletion {
	param(
		[string]$WordToComplete,
		[System.Management.Automation.Language.CommandAst]$CommandAst,
		[int]$CursorPosition,
		[int]$runIndex, # 'run' 命令在 CommandAst 中的索引。
		[int]$Argindex  # 当前参数在 CommandAst 中的索引。
	)

	# 提取用户名和 shellname，处理它们可能还不存在的情况。
	# $runIndex + 1 是parttype的可能位置。
	# $runIndex + 2 是用户名的可能位置。
	# $runIndex + 3 是 partname 的可能位置。
	# 如果索引在 CommandAst 的范围内，并且元素是字符串常量，则提取其值。
	$parttype = if ($runIndex + 1 -lt $CommandAst.CommandElements.Count -and $CommandAst.CommandElements[$runIndex + 1] -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
		$CommandAst.CommandElements[$runIndex + 1].Value
	}
	$username = if ($runIndex + 2 -lt $CommandAst.CommandElements.Count -and $CommandAst.CommandElements[$runIndex + 2] -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
		$CommandAst.CommandElements[$runIndex + 2].Value
	}
	$partname = if ($runIndex + 3 -lt $CommandAst.CommandElements.Count -and $CommandAst.CommandElements[$runIndex + 3] -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
		$CommandAst.CommandElements[$runIndex + 3].Value
	}

	# 补全类型。
	# 如果当前参数是 'run' 之后的第一个参数，则补全类型。
	if (($ArgIndex - $runIndex) -eq 1) {
		return Get-FountPartTypeList | Where-Object { $_.StartsWith($WordToComplete) }
	}

	# 补全用户名。
	# 如果当前参数是 'run' 之后的第二个参数，则补全用户名。
	if (($ArgIndex - $runIndex) -eq 2) {
		return Get-FountUserList | Where-Object { $_.StartsWith($WordToComplete) }
	}

	# 补全 partname。
	# 如果当前参数是 'run' 之后的第三个参数，则补全 partname。
	if (($ArgIndex - $runIndex) -eq 3) {
		return Get-FountPartListWithCompleter $username $parttype | Where-Object { $_.StartsWith($WordToComplete) }
	}

	# 委托给 shell 的 argument_completer.ps1 脚本处理后续参数。
	# 获取 shell 目录的路径。
	$shellDir = Get-FountPartDirectory -Username $username -parttype $parttype -partname $partname
	# 如果 shell 目录存在，并且包含 argument_completer.ps1 脚本（-PathType Leaf 检查是否为文件），则执行该脚本。
	if (Test-Path (Join-Path -Path $shellDir -ChildPath "argument_completer.ps1") -PathType Leaf) {
		# 使用 '&' 调用操作符执行脚本，并传递必要的参数。
		& (Join-Path -Path $shellDir -ChildPath "argument_completer.ps1") $username $WordToComplete $CommandAst $CursorPosition $runIndex $Argindex
	}
}

# 定义 fount 工具的参数结构。
$ArgumentStructure = @{
	Root = @{
		# 根节点包含的参数。
		Parameters = 'background', 'geneexe', 'init', 'keepalive', 'run', 'shutdown', 'reboot', 'clean'
		# 'background' 参数的子参数。
		background = @{
			Parameters = 'geneexe', 'init', 'keepalive', 'run', 'shutdown', 'reboot', 'clean'
			# 'geneexe' 参数的处理程序（仅限 Windows）。
			geneexe    = { if ($IsWindows) { Get-ChildItem -Path "$($WordToComplete)*" -File | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'File', $_.FullName) } } }
			init       = $null  # 没有补全逻辑。
			# 'keepalive' 参数的子参数和处理程序。
			keepalive  = @{ Parameters = 'debug', 'run'; debug = @{ Parameters = 'run'; run = ${function:Invoke-RunshellCompletion} }; run = ${function:Invoke-RunshellCompletion} }
			# 'run' 参数的处理程序。
			run        = ${function:Invoke-RunshellCompletion}
			shutdown   = $null
			reboot     = $null
			clean      = $null
		}
		geneexe    = { if ($IsWindows) { Get-ChildItem -Path "$($WordToComplete)*" -File | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.FullName, $_.Name, 'File', $_.FullName) } } }
		init       = $null
		keepalive  = @{ Parameters = 'debug', 'run'; debug = @{ Parameters = 'run'; run = ${function:Invoke-RunshellCompletion} }; run = ${function:Invoke-RunshellCompletion} }
		debug      = @{ Parameters = 'run'; run = ${function:Invoke-RunshellCompletion} }
		run        = ${function:Invoke-RunshellCompletion}
		shutdown   = $null
		reboot     = $null
		clean      = $null
	}
}

# 如果不是 Windows 系统，则移除 'geneexe' 参数。
if (-not $IsWindows) {
	Remove-ArgumentNode -Node $ArgumentStructure.Root -Key 'geneexe'
}

# fount 工具的主参数补全函数。
function Get-FountArgumentCompletion {
	param(
		[string]$WordToComplete,
		[System.Management.Automation.Language.CommandAst]$CommandAst,
		[int]$CursorPosition
	)

	try {
		# 改进的提取 $realWordToComplete 的逻辑。  这段代码尝试更准确地确定用户正在输入的单词。
		$WordToComplete = "$CommandAst"  # 首先将整个命令字符串赋值给 $WordToComplete。
		# 循环添加空格，直到 $WordToComplete 的长度大于等于光标位置。这确保了后续的字符串分割可以正确工作，即使光标后面有空格。
		while ($CursorPosition -gt $WordToComplete.Length) {
			$WordToComplete += ' '
		}
		# 将 $WordToComplete 截取到光标位置，然后按空格分割，得到一个单词数组。
		$CommandWords = $WordToComplete.Substring(0, [Math]::Min($WordToComplete.Length, $CursorPosition)) -split '\s+'
		# $Argindex 是当前参数的索引。
		$Argindex = $CommandWords.Count - 1
		# $WordToComplete 现在是用户正在输入的单词。
		$WordToComplete = $CommandWords[-1]

		# 从参数结构的根节点开始。
		$currentLevel = $ArgumentStructure.Root

		# 跳过命令名称（例如 'fount'）。
		$ArgCommandElements = $CommandAst.CommandElements | Select-Object -Skip 1

		$rootIndex = 0 # 用于跟踪runshel​​l参数的索引

		# 遍历命令参数。
		foreach ($element in $ArgCommandElements) {
			# 如果元素是字符串常量。
			if ($element -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
				$argValue = $element.Value

				# 如果当前级别是哈希表，并且包含该参数值。
				if ($currentLevel -is [hashtable] -and $currentLevel.ContainsKey($argValue)) {
					# 移动到下一级。
					$currentLevel = $currentLevel[$argValue]
					$rootIndex += 1
				}
				# 否则，如果当前级别是哈希表，并且包含 "Parameters" 键，并且 "Parameters" 包含该参数值, 则不做任何事情，因为我们已经处理了有效的参数。
				elseif ($currentLevel -is [hashtable] -and $currentLevel.ContainsKey("Parameters") -and ($currentLevel.Parameters -contains $argValue)) {
				}
				# 否则，参数无效，退出循环。
				else {
					break
				}
			}
			# 否则，参数不是字符串常量，退出循环。
			else {
				break
			}
		}

		# 如果当前级别是哈希表。
		if ($currentLevel -is [hashtable]) {
			# 如果包含 "Parameters" 键。
			if ($currentLevel.ContainsKey("Parameters")) {
				# 获取匹配的参数。
				$parameters = $currentLevel.Parameters
				$matchingParameters = $parameters | Where-Object { $_.StartsWith($WordToComplete) }
				# 返回匹配的参数。
				$matchingParameters
				return
			}
			return
		}
		# 否则，如果当前级别是脚本块。
		elseif ($currentLevel -is [scriptblock]) {
			# 执行脚本块，并传递必要的参数。
			& $currentLevel $WordToComplete $CommandAst $CursorPosition $rootIndex $Argindex | ForEach-Object { $_ }
			return
		}
	}
	catch {
		# 捕获并显示错误信息。
		Write-Host "Error in Get-FountArgumentCompletion: $_" -ForegroundColor Red
	}
}

# 注册参数补全函数。
# 为 'fount'、'fount.ps1'、'fount.cmd' 和 'fount.exe' 命令注册 Get-FountArgumentCompletion 函数。
Register-ArgumentCompleter -CommandName fount -ScriptBlock ${function:Get-FountArgumentCompletion} -Native
Register-ArgumentCompleter -CommandName fount.ps1 -ScriptBlock ${function:Get-FountArgumentCompletion} -Native
Register-ArgumentCompleter -CommandName fount.cmd -ScriptBlock ${function:Get-FountArgumentCompletion} -Native
Register-ArgumentCompleter -CommandName fount.exe -ScriptBlock ${function:Get-FountArgumentCompletion} -Native
