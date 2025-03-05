# fount-pwsh

[![Nombre de téléchargements PSGallery](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** est un outil qui vous permet d'utiliser facilement **Fount** dans les terminaux PowerShell (pwsh) ou esh.
Il peut vous aider à mieux utiliser votre shell, ou simplement à discuter avec des rôles dans le shell.

![Image : exemple d'utilisation de fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Installation

Utilisez cette commande pour installer le module `fount-pwsh` :

```powershell
Install-Module fount-pwsh
```

**Note :** `fount-pwsh` dépend de [Fount](https://github.com/steve02081504/fount) pour fonctionner.
Mais ne vous inquiétez pas !
Si vous n'avez pas encore installé Fount, `fount-pwsh` **installera automatiquement Fount pour vous** la première fois que vous utiliserez les commandes suivantes :

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Configurer l'assistant

Vous avez besoin d'un **rôle Fount** qui prend en charge l'**interface `shellassist`**.

> [!WARNING]
> **À propos des performances de PowerShell**
>
> Dans PowerShell, le chargement d'un assistant Fount prend **environ 600 millisecondes** en moyenne. Cela peut légèrement affecter la vitesse de démarrage de votre shell. (Pour esh, le chargement est **instantané**.)
>
> Si vous souhaitez que PowerShell démarre plus rapidement, vous pouvez envisager de configurer le chargement de l'assistant Fount en **chargement en arrière-plan** (consultez l'[enregistrement d'événements](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) de PowerShell et l'événement [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)).

**Deux façons d'activer votre assistant :**

**1. Configuration automatique (recommandée) :**

Utilisez cette commande pour que l'assistant Fount démarre automatiquement et fournisse de l'aide chaque fois que vous ouvrez une nouvelle fenêtre shell :

```powershell
Install-FountAssist <Votre nom d'utilisateur Fount> <Nom de rôle requis>
```

Remplacez `<Votre nom d'utilisateur Fount>` et `<Nom de rôle requis>` par votre nom d'utilisateur et nom de rôle Fount réels.

**2. Configuration manuelle (pour les utilisateurs avancés) :**

Si vous souhaitez le configurer manuellement, vous pouvez ajouter le code suivant à votre fichier de **profil shell** :

```powershell
Set-FountAssist <Votre nom d'utilisateur Fount> <Nom de rôle requis>
```

## Quand l'assistant apparaît-il ?

L'assistant Fount apparaîtra automatiquement dans les situations suivantes :

- **Lorsque vous entrez une commande incorrecte** (comme une faute de frappe).
- **Lorsqu'une commande que vous exécutez échoue** (la valeur de `$?` est fausse).
- **Lorsque vous utilisez activement la commande `f`**

## Désactiver/Activer l'assistant automatique

Vous pouvez utiliser la commande `f` pour désactiver ou activer facilement la fonction d'assistant automatique :

```powershell
f 0    # Désactiver l'assistant automatique (également possible avec f false / f no / f n / f disable / f unset / f off etc.)
f 1    # Activer l'assistant automatique (également possible avec f true / f yes / f y / f enable / f set / f on etc.)
```
