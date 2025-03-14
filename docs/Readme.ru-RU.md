# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![Количество загрузок PSGallery](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** — это инструмент, который позволяет вам легко использовать **Fount** в терминалах PowerShell (pwsh) или esh.
Он может помочь вам лучше использовать свою оболочку или просто общаться с ролями в оболочке.

![Изображение: пример использования fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Установка

Используйте эту команду для установки модуля `fount-pwsh`:

```powershell
Install-Module fount-pwsh
```

**Примечание:** `fount-pwsh` зависит от [Fount](https://github.com/steve02081504/fount) для работы.
Но не волнуйтесь!
Если вы еще не установили Fount, `fount-pwsh` **автоматически установит Fount для вас** при первом использовании следующих команд:

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Настройка помощника

Вам нужна **роль Fount**, поддерживающая **интерфейс `shellassist`**.

> [!WARNING]
> **О производительности PowerShell**
>
> В PowerShell загрузка помощника Fount занимает в среднем **около 600 миллисекунд**. Это может немного повлиять на скорость запуска вашей оболочки. (Для esh загрузка **мгновенная**.)
>
> Если вы хотите, чтобы PowerShell запускался быстрее, вы можете рассмотреть возможность настройки загрузки помощника Fount на **фоновую загрузку** (см. [регистрацию событий](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) PowerShell и событие [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)).

**Два способа включить вашего помощника:**

**1. Автоматическая настройка (рекомендуется):**

Используйте эту команду, чтобы помощник Fount автоматически запускался и предоставлял помощь каждый раз, когда вы открываете новое окно оболочки:

```powershell
Install-FountAssist <Ваше имя пользователя Fount> <Требуемое имя роли>
```

Замените `<Ваше имя пользователя Fount>` и `<Требуемое имя роли>` на ваше фактическое имя пользователя Fount и имя роли.

**2. Ручная настройка (для опытных пользователей):**

Если вы хотите настроить вручную, вы можете добавить следующий код в файл вашего **профиля оболочки**:

```powershell
Set-FountAssist <Ваше имя пользователя Fount> <Требуемое имя роли>
```

## Когда появляется помощник?

Помощник Fount будет автоматически появляться в следующих ситуациях:

- **Когда вы вводите неверную команду** (например, опечатку).
- **Когда команда, которую вы запускаете, не выполняется** (значение `$?` равно false).
- **Когда вы активно используете команду `f`**

## Отключение/Включение автоматического помощника

Вы можете использовать команду `f`, чтобы легко отключить или включить функцию автоматического помощника:

```powershell
f 0    # Отключить автоматического помощника (также возможно с f false / f no / f n / f disable / f unset / f off и т. д.)
f 1    # Включить автоматического помощника (также возможно с f true / f yes / f y / f enable / f set / f on и т. д.)
```
