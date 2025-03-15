# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![Número de downloads do PSGallery](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** é uma ferramenta que permite usar facilmente o **Fount** em terminais PowerShell (pwsh) ou esh.
Pode ajudá-lo a usar melhor a sua shell ou simplesmente conversar com funções na shell.

![Imagem: exemplo de uso do fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Instalação

Use este comando para instalar o módulo `fount-pwsh`:

```powershell
Install-Module fount-pwsh
```

**Nota:** `fount-pwsh` depende do [Fount](https://github.com/steve02081504/fount) para funcionar.
Mas não se preocupe!
Se ainda não instalou o Fount, o `fount-pwsh` **instalará automaticamente o Fount para si** na primeira vez que usar os seguintes comandos:

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Configurar Assistente

Precisa de uma **função Fount** que suporte a **interface `shellassist`**.

> [!WARNING]
> **Sobre o desempenho do PowerShell**
>
> No PowerShell, carregar um assistente Fount demora **cerca de 600 milissegundos** em média. Isso pode afetar ligeiramente a velocidade de inicialização da sua shell. (Para esh, o carregamento é **instantâneo**.)
>
> Se quiser que o PowerShell inicie mais rapidamente, pode considerar definir o carregamento do assistente Fount para **carregamento em segundo plano** (consulte o [registo de eventos](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) do PowerShell e o evento [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)).

**Duas maneiras de ativar o seu assistente:**

**1. Configuração Automática (Recomendado):**

Use este comando para que o assistente Fount inicie automaticamente e forneça assistência sempre que abrir uma nova janela de shell:

```powershell
Install-FountAssist <O Seu Nome de Utilizador Fount> <Nome da Função Necessária>
```

Substitua `<O Seu Nome de Utilizador Fount>` e `<Nome da Função Necessária>` pelo seu nome de utilizador e nome de função Fount reais.

**2. Configuração Manual (Para Utilizadores Avançados):**

Se quiser configurar manualmente, pode adicionar o seguinte código ao seu ficheiro de **perfil de shell**:

```powershell
Set-FountAssist <O Seu Nome de Utilizador Fount> <Nome da Função Necessária>
```

## Quando é que o assistente aparece?

O assistente Fount aparecerá automaticamente nas seguintes situações:

- **Quando introduz um comando incorreto** (como um erro ortográfico).
- **Quando um comando que executa falha** (o valor de `$?` é falso).
- **Quando usa ativamente o comando `f`**

## Desativar/Ativar Assistente Automático

Pode usar o comando `f` para desativar ou ativar facilmente a funcionalidade de assistente automático:

```powershell
f 0    # Desativar assistente automático (também possível com f false / f no / f n / f disable / f unset / f off etc.)
f 1    # Ativar assistente automático (também possível com f true / f yes / f y / f enable / f set / f on etc.)
```
