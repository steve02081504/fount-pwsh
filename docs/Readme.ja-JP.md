# fount-pwsh

[![PSGallery ダウンロード数](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** は、PowerShell (pwsh) または esh ターミナルで **Fount** を簡単に使用できるようにするツールです。
シェルをより有効に活用したり、シェル内でロールとチャットしたりするのに役立ちます。

![画像: fount-pwsh の使用例](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## インストール

`fount-pwsh` モジュールをインストールするには、次のコマンドを使用します。

```powershell
Install-Module fount-pwsh
```

**注意:** `fount-pwsh` は、[Fount](https://github.com/steve02081504/fount) が動作することを前提としています。
ただし、ご心配なく。
Fount をまだインストールしていない場合でも、`fount-pwsh` は、以下のコマンドを初めて使用するときに **自動的に Fount をインストール** します。

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## アシスタントの設定

**`shellassist` インターフェース** をサポートする **Fount ロール** が必要です。

> [!WARNING]
> **PowerShell のパフォーマンスについて**
>
> PowerShell では、Fount アシスタントのロードには平均して **約 600 ミリ秒** かかります。これにより、シェルの起動速度がわずかに影響を受ける可能性があります。（esh の場合、ロードは **瞬間的** です。）
>
> PowerShell の起動を高速化したい場合は、Fount アシスタントのロードを **バックグラウンドロード** に設定することを検討してください（PowerShell の[イベント登録](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) および [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0) イベントを参照）。

**アシスタントを有効にする 2 つの方法:**

**1. 自動構成 (推奨):**

新しいシェルウィンドウを開くたびに、Fount アシスタントが自動的に起動して支援を提供するようにするには、このコマンドを使用します。

```powershell
Install-FountAssist <Fount ユーザー名> <必要なロール名>
```

`<Fount ユーザー名>` と `<必要なロール名>` を実際の Fount ユーザー名とロール名に置き換えてください。

**2. 手動構成 (高度なユーザー向け):**

手動で設定する場合は、次のコードを **シェルプロファイル** ファイルに追加できます。

```powershell
Set-FountAssist <Fount ユーザー名> <必要なロール名>
```

## アシスタントはいつ表示されますか？

Fount アシスタントは、次の状況で自動的に表示されます。

- **間違ったコマンドを入力した場合**（スペルミスなど）。
- **実行したコマンドの実行に失敗した場合** (`$?` の値が false の場合)。
- **`f` コマンドをアクティブに使用する場合**

## 自動アシスタントの無効化/有効化

`f` コマンドを使用すると、自動アシスタント機能を簡単に無効または有効にできます。

```powershell
f 0    # 自動アシスタントを無効にする (f false / f no / f n / f disable / f unset / f off なども可能)
f 1    # 自動アシスタントを有効にする (f true / f yes / f y / f enable / f set / f on なども可能)
```
