# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![PSGallery download num](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** è uno strumento che ti permette di usare facilmente [fount](https://github.com/steve02081504/fount) nei terminali PowerShell o esh.
Può aiutarti a usare meglio la tua shell, o semplicemente a chattare con i ruoli nella shell.

![Immagine: esempio di utilizzo di fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Installazione

Usa questo comando per installare il modulo `fount-pwsh`:

```powershell
Install-Module fount-pwsh
```

**Nota:** `fount-pwsh` dipende da [fount](https://github.com/steve02081504/fount) per funzionare.
Ma non preoccuparti!
Se non hai ancora installato fount, `fount-pwsh` **installerà automaticamente fount per te** la prima volta che usi i seguenti comandi:

- `Start-fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Configura Assistente

> [!WARNING]
> **Informazioni sulle prestazioni di PowerShell**
>
> In PowerShell, il caricamento di un assistente fount richiede in media **circa 600 millisecondi**. Ciò potrebbe influire leggermente sulla velocità di avvio della shell. (Per esh, il caricamento è **istantaneo**.)
>
> Se desideri che PowerShell si avvii più velocemente, puoi considerare di impostare il caricamento dell'assistente fount su **caricamento in background** (fai riferimento alla [registrazione degli eventi](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) di PowerShell e all'evento [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)).

**Due modi per abilitare il tuo assistente:**

**1. Configurazione Automatica (Consigliata):**

Usa questo comando per far sì che l'assistente fount si avvii automaticamente e fornisca assistenza ogni volta che apri una nuova finestra della shell:

```powershell
Install-FountAssist <Tuo Nome Utente fount> <Nome Ruolo Richiesto>
```

Sostituisci `<Tuo Nome Utente fount>` e `<Nome Ruolo Richiesto>` con il tuo nome utente fount effettivo e il nome del ruolo.

**2. Configurazione Manuale (Per Utenti Esperti):**

Se vuoi configurarlo manualmente, puoi aggiungere il seguente codice al tuo file di **profilo della shell**:

```powershell
Set-FountAssist <Tuo Nome Utente fount> <Nome Ruolo Richiesto>
```

## Quando appare l'assistente?

L'assistente fount apparirà automaticamente nelle seguenti situazioni:

- **Quando inserisci un comando errato** (come un errore di battitura).
- **Quando un comando che esegui non riesce** (il valore di `$?` è falso).
- **Quando usi attivamente il comando `f`**

## Disabilita/Abilita Assistente Automatico

Puoi usare il comando `f` per disabilitare o abilitare facilmente la funzione di assistente automatico:

```powershell
f 0    # Disabilita assistente automatico (possibile anche con f false / f no / f n / f disable / f unset / f off ecc.)
f 1    # Abilita assistente automatico (possibile anche con f true / f yes / f y / f enable / f set / f on ecc.)
```
