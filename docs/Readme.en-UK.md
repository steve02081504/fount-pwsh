# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![PSGallery download num](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** is a tool that allows you to easily use [fount](https://github.com/steve02081504/fount) in PowerShell or esh terminals.
It can help you use your shell better, or just chat with roles in the shell.

![Image: fount-pwsh usage example](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Installation

Use this command to install the `fount-pwsh` module:

```powershell
Install-Module fount-pwsh
```

**Note:** `fount-pwsh` relies on [fount](https://github.com/steve02081504/fount) to work.
But don't worry!
If you haven't installed fount yet, `fount-pwsh` will **automatically install fount for you** the first time you use the following commands:

- `Start-fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Configure Assistant

You need a **fount role** that supports the **`shellassist` interface**.

> [!WARNING]
> **About PowerShell performance**
>
> In PowerShell, loading a fount assistant takes **about 600 milliseconds** on average. This may slightly affect your shell startup speed. (For esh, loading is **instantaneous**.)
>
> If you want PowerShell to start faster, you can consider setting the loading of the fount assistant to **background loading** (refer to PowerShell's [event registration](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) and [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0) event).

**Two ways to enable your assistant:**

**1. Automatic Configuration (Recommended):**

Use this command to have the fount assistant automatically start and provide assistance each time you open a new shell window:

```powershell
Install-FountAssist <Your fount Username> <Required Role Name>
```

Replace `<Your fount Username>` and `<Required Role Name>` with your actual fount username and role name.

**2. Manual Configuration (For Advanced Users):**

If you want to set it up manually, you can add the following code to your **shell profile** file:

```powershell
Set-FountAssist <Your fount Username> <Required Role Name>
```

## When does the assistant appear?

The fount assistant will automatically appear in the following situations:

- **When you enter an incorrect command** (such as a spelling error).
- **When a command you run fails to execute** (the value of `$?` is false).
- **When you actively use the `f` command**

## Disable/Enable Automatic Assistant

You can use the `f` command to easily disable or enable the automatic assistant feature:

```powershell
f 0    # Disable automatic assistant (also possible with f false / f no / f n / f disable / f unset / f off etc.)
f 1    # Enable automatic assistant (also possible with f true / f yes / f y / f enable / f set / f on etc.)
```
