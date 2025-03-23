$script:FountEncoding = [System.Text.Encoding]::UTF8

$script:FountClient = $null
$script:FountStream = $null
function Set-FountClient($ComputerName = "localhost", $Port = 16698, $timeout = 100) {
	if ($script:FountClient) {
		if ($script:FountClient.Connected) {
			return $script:FountClient
		}
		else {
			Close-FountClient
		}
	}

	# 创建新的 TCP 客户端
	$Client = New-Object System.Net.Sockets.TcpClient
	if ($Client.ConnectAsync($ComputerName, $Port).Wait($timeout)) {
		if ($Client.Connected) {
			Write-Verbose "成功连接到 fount 服务器。"
			$script:FountClient = $Client
			return
		}
	}
	Write-Error "无法连接到 fount 服务器" -ErrorAction Stop
}
function Close-FountClient {
	if ($script:FountStream) {
		$script:FountStream.Dispose()
		$script:FountStream = $null
	}
	if ($script:FountClient) {
		if ($script:FountClient.Connected) {
			$script:FountClient.Close()
		}
		$script:FountClient.Dispose()
		$script:FountClient = $null
	}
}

function Invoke-FountIPC(
	[string]$Type,
	[hashtable]$Data,
	[string]$ComputerName = "localhost",
	[int]$Port = 16698
) {
	# 构建要发送的完整 JSON 对象
	$CommandObject = @{
		type = $Type
		data = $Data
	}
	$JsonCommand = $CommandObject | ConvertTo-Json -Compress -Depth 100
	$JsonCommand += "`n"  # 添加换行符作为消息结束符

	try {
		# 获取或建立连接
		if (-not $script:FountClient) {
			Set-FountClient -ComputerName $ComputerName -Port $Port
			if (-not $script:FountClient) {
				Write-Error "无法连接到 fount 服务器" -ErrorAction Stop
			}
		}
		if (-not $script:FountClient.Connected) {
			$script:FountClient.Connect($ComputerName, $Port)
			if ($script:FountStream) {
				$script:FountStream.Dispose()
			}
			$script:FountStream = $null
		}
		if (-not $script:FountStream) {
			$script:FountStream = $script:FountClient.GetStream()
		}

		# 获取网络流
		$Stream = $script:FountStream
		$Encoding = $script:FountEncoding

		# 发送数据
		$Bytes = $Encoding.GetBytes($JsonCommand)
		$Stream.Write($Bytes, 0, $Bytes.Length)
		$Stream.Flush()

		# 读取响应（支持大响应和分块读取）
		$MemoryStream = New-Object System.IO.MemoryStream
		$Buffer = New-Object byte[] 4096
		$FoundTerminator = $false

		do {
			$Read = $Stream.Read($Buffer, 0, $Buffer.Length)
			if ($Read -gt 0) {
				$MemoryStream.Write($Buffer, 0, $Read)
				# 检查是否包含换行符
				$CurrentData = $Encoding.GetString($MemoryStream.ToArray())
				if ($CurrentData -match "`n") {
					$FoundTerminator = $true
					break
				}
			}
		} while ($Read -gt 0 -and -not $FoundTerminator)

		# 提取有效响应
		$ResponseString = $Encoding.GetString($MemoryStream.ToArray())

		# 解析 JSON 响应
		if (-not [string]::IsNullOrEmpty($ResponseString)) {
			$result = ConvertFrom-Json -InputObject $ResponseString
			if ($result.status -ne 'ok') {
				Write-Error "与 fount 服务器通信失败: $($result.message)" -ErrorAction Stop
			}
			else {
				return $result.data
			}
		}
		else {
			Write-Error "收到空响应" -ErrorAction Stop
		}
	}
	finally {
		if ($MemoryStream) {
			$MemoryStream.Dispose()
		}
	}
}

function Start-FountShell {
	param(
		[Parameter(Mandatory)]
		[string]$UserName,

		[Parameter(Mandatory)]
		[string]$ShellName,

		[Parameter(ValueFromRemainingArguments)]
		[array]$Arguments
	)

	Invoke-FountIPC -Type "runshell" -Data @{
		username  = $UserName
		shellname = $ShellName
		args      = $Arguments
	}
}

function Invoke-FountShell {
	param (
		[Parameter(Mandatory)]
		[string]$UserName,

		[Parameter(Mandatory)]
		[string]$ShellName,

		$Data
	)

	Invoke-FountIPC -Type "invokeshell" -Data @{
		username  = $UserName
		shellname = $ShellName
		data      = $Data
	}
}

function Test-FountRunning {
	try {
		Invoke-FountIPC -Type "ping" -ErrorAction Stop | Out-Null
		$true
	}
	catch {
		$false
	}
}

function Install-Fount {
	$scriptContent = Invoke-RestMethod https://raw.githubusercontent.com/steve02081504/fount/refs/heads/master/src/runner/main.ps1
	Invoke-Expression "function fountInstaller { $scriptContent }"
	fountInstaller @args
}

function Start-Fount(
	[switch] $NoAutoInstall
) {
	if (Get-Command fount -ErrorAction SilentlyContinue) {
		fount @args
	}
	elseif (!$NoAutoInstall) {
		Install-Fount @args
	}
	else {
		Write-Error "fount 未安装"
	}
}

function Stop-Fount {
	Invoke-FountIPC -Type "shutdown"
	Close-FountClient
}
