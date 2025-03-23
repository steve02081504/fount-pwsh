# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![PSGallery Download-Anzahl](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** ist ein Tool, mit dem Sie [fount](https://github.com/steve02081504/fount) einfach in PowerShell oder esh-Terminals verwenden können.
Es kann Ihnen helfen, Ihre Shell besser zu nutzen oder einfach nur mit Rollen in der Shell zu chatten.

![Bild: fount-pwsh Anwendungsbeispiel](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Installation

Verwenden Sie diesen Befehl, um das `fount-pwsh`-Modul zu installieren:

```powershell
Install-Module fount-pwsh
```

**Hinweis:** `fount-pwsh` ist darauf angewiesen, dass [fount](https://github.com/steve02081504/fount) funktioniert.
Aber keine Sorge!
Wenn Sie fount noch nicht installiert haben, installiert `fount-pwsh` **fount automatisch für Sie**, wenn Sie zum ersten Mal die folgenden Befehle verwenden:

- `Start-fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Assistent konfigurieren

Sie benötigen eine **fount-Rolle**, die die **`shellassist` Schnittstelle** unterstützt.

> [!WARNING]
> **Über die PowerShell-Leistung**
>
> In PowerShell dauert das Laden eines fount-Assistenten durchschnittlich **etwa 600 Millisekunden**. Dies kann die Startgeschwindigkeit Ihrer Shell leicht beeinträchtigen. (Für esh ist das Laden **augenblicklich**.)
>
> Wenn Sie möchten, dass PowerShell schneller startet, können Sie das Laden des fount-Assistenten auf **Hintergrundladen** einstellen (siehe PowerShell [Ereignisregistrierung](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) und [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0) Ereignis).

**Zwei Methoden zum Aktivieren Ihres Assistenten:**

**1. Automatische Konfiguration (empfohlen):**

Mit diesem Befehl können Sie den fount-Assistenten automatisch starten und Hilfe leisten lassen, wenn Sie ein neues Shell-Fenster öffnen:

```powershell
Install-FountAssist <Ihr fount-Benutzername> <Name der benötigten Rolle>
```

Ersetzen Sie `<Ihr fount-Benutzername>` und `<Name der benötigten Rolle>` durch Ihren tatsächlichen fount-Benutzernamen und Rollennamen.

**2. Manuelle Konfiguration (für fortgeschrittene Benutzer):**

Wenn Sie dies manuell einrichten möchten, können Sie den folgenden Code zu Ihrer **Shell-Profildatei** hinzufügen:

```powershell
Set-FountAssist <Ihr fount-Benutzername> <Name der benötigten Rolle>
```

## Wann erscheint der Assistent?

Der fount-Assistent erscheint automatisch in den folgenden Fällen:

- **Wenn Sie einen falschen Befehl eingegeben haben** (z. B. Tippfehler).
- **Wenn die Ausführung eines Befehls fehlschlägt** (der Wert von `$?` ist falsch).
- **Wenn Sie den Befehl `f` aktiv verwenden**

## Automatischen Assistenten deaktivieren/aktivieren

Sie können den Befehl `f` verwenden, um die automatische Assistentenfunktion einfach zu deaktivieren oder zu aktivieren:

```powershell
f 0    # Automatischen Assistenten deaktivieren (auch möglich mit f false / f no / f n / f disable / f unset / f off usw.)
f 1    # Automatischen Assistenten aktivieren (auch möglich mit f true / f yes / f y / f enable / f set / f on usw.)
```
