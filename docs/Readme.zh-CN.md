# fount-pwsh

[![PSGallery 下载量](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** 是一个工具，它可以让你在 PowerShell (pwsh) 或 esh 终端中轻松使用 **Fount**。
它可以帮你更好地使用 shell，或只是在 shell 里和角色聊天。

![图片：fount-pwsh 使用示例](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## 安装

使用这个命令安装 `fount-pwsh` 模块：

```powershell
Install-Module fount-pwsh
```

**注意：** `fount-pwsh` 依赖于 [Fount](https://github.com/steve02081504/fount) 工作。
不过别担心！
如果你还没有安装 Fount，`fount-pwsh` 会在你第一次使用以下命令时 **自动帮你安装 Fount**：

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## 配置助手

你需要一个支持 **`shellassist` 界面** 的 **Fount 角色**。

> [!WARNING]
> **关于 PowerShell 性能**
>
> 在 PowerShell 中，加载 Fount 助手平均需要 **大约 600 毫秒**。 这可能会稍微影响你的 shell 启动速度。 (对于 esh 来说，加载是 **瞬间的**。)
>
> 如果你希望 PowerShell 启动更快，可以考虑将 Fount 助手的加载设置为 **后台加载** (参阅powershell的[事件注册](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5)和[OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)事件)。

**两种方法启用你的助手：**

**1. 自动配置 (推荐):**

使用这个命令，可以让 Fount 助手在每次你打开新的 shell 窗口时自动启动并提供帮助：

```powershell
Install-FountAssist <你的 Fount 用户名> <需要的角色名>
```

将 `<你的 Fount 用户名>` 和 `<需要的角色名>` 替换为你实际的 Fount 用户名和角色名称。

**2. 手动配置 (适用于高级用户):**

如果你想手动设置，可以将以下代码添加到你的 **shell profile** 文件中：

```powershell
Set-FountAssist <你的 Fount 用户名> <需要的角色名>
```

## 助手什么时候会出现？

Fount 助手会在以下这些情况下自动出现：

- **当你输入了错误的命令时** (如拼写错误)。
- **当你运行的命令执行失败时** (`$?` 的值为 false)。
- **当你主动使用 `f` 命令时**

## 禁用/启用 自动助手

你可以使用 `f` 命令来轻松地禁用或启用自动助手功能：

```powershell
f 0    # 禁用自动助手 (也可以用 f false / f no / f n / f disable / f unset / f off 等)
f 1    # 启用自动助手 (也可以用 f true / f yes / f y / f enable / f set / f on 等)
```
