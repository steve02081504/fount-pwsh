# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![Número de descargas de PSGallery](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** es una herramienta que te permite usar [fount](https://github.com/steve02081504/fount) fácilmente en terminales PowerShell o esh.
Puede ayudarte a usar mejor tu shell, o simplemente chatear con roles en la shell.

![Imagen: ejemplo de uso de fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Instalación

Usa este comando para instalar el módulo `fount-pwsh`:

```powershell
Install-Module fount-pwsh
```

**Nota:** `fount-pwsh` depende de que [fount](https://github.com/steve02081504/fount) funcione.
¡Pero no te preocupes!
Si aún no has instalado fount, `fount-pwsh` **instalará fount automáticamente por ti** la primera vez que uses los siguientes comandos:

- `Start-fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Configurar Asistente

> [!WARNING]
> **Acerca del rendimiento de PowerShell**
>
> En PowerShell, cargar un asistente de fount lleva **unos 600 milisegundos** de media. Esto puede afectar ligeramente la velocidad de inicio de tu shell. (Para esh, la carga es **instantánea**).
>
> Si quieres que PowerShell se inicie más rápido, puedes considerar configurar la carga del asistente de fount en **carga en segundo plano** (consulta el [registro de eventos](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) y el evento [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0) de PowerShell).

**Dos maneras de habilitar tu asistente:**

**1. Configuración Automática (Recomendada):**

Usa este comando para que el asistente de fount se inicie automáticamente y te proporcione ayuda cada vez que abras una nueva ventana de shell:

```powershell
Install-FountAssist <Tu Nombre de Usuario de fount> <Nombre del Rol Requerido>
```

Reemplaza `<Tu Nombre de Usuario de fount>` y `<Nombre del Rol Requerido>` con tu nombre de usuario y nombre de rol reales de fount.

**2. Configuración Manual (Para Usuarios Avanzados):**

Si quieres configurarlo manualmente, puedes añadir el siguiente código a tu archivo de **perfil de shell**:

```powershell
Set-FountAssist <Tu Nombre de Usuario de fount> <Nombre del Rol Requerido>
```

## ¿Cuándo aparece el asistente?

El asistente de fount aparecerá automáticamente en las siguientes situaciones:

- **Cuando introduces un comando incorrecto** (como un error ortográfico).
- **Cuando un comando que ejecutas falla** (el valor de `$?` es falso).
- **Cuando usas activamente el comando `f`**

## Desactivar/Activar Asistente Automático

Puedes usar el comando `f` para desactivar o activar fácilmente la función de asistente automático:

```powershell
f 0    # Desactivar asistente automático (también posible con f false / f no / f n / f disable / f unset / f off etc.)
f 1    # Activar asistente automático (también posible con f true / f yes / f y / f enable / f set / f on etc.)
```
