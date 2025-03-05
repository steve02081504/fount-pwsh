# fount-pwsh

[![PSGallery 다운로드 수](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh**는 PowerShell (pwsh) 또는 esh 터미널에서 **Fount**를 쉽게 사용할 수 있도록 하는 도구입니다.
쉘을 더 잘 사용하거나 쉘에서 역할과 채팅하는 데 도움이 될 수 있습니다.

![이미지: fount-pwsh 사용 예시](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## 설치

`fount-pwsh` 모듈을 설치하려면 다음 명령을 사용하십시오:

```powershell
Install-Module fount-pwsh
```

**주의:** `fount-pwsh`는 [Fount](https://github.com/steve02081504/fount)가 작동하는 데 의존합니다.
하지만 걱정하지 마세요!
아직 Fount를 설치하지 않은 경우, `fount-pwsh`는 다음 명령을 처음 사용할 때 **자동으로 Fount를 설치**합니다:

- `Start-Fount`
- `Set-FountAssist`
- `Install-FountAssist`

## 어시스턴트 설정

**`shellassist` 인터페이스**를 지원하는 **Fount 역할**이 필요합니다.

> [!WARNING]
> **PowerShell 성능 정보**
>
> PowerShell에서 Fount 어시스턴트를 로드하는 데 평균적으로 **약 600밀리초**가 걸립니다. 이는 쉘 시작 속도에 약간 영향을 줄 수 있습니다. (esh의 경우 로드는 **즉각적**입니다.)
>
> PowerShell이 더 빠르게 시작되기를 원한다면 Fount 어시스턴트의 로드를 **백그라운드 로딩**으로 설정하는 것을 고려할 수 있습니다 (PowerShell의 [이벤트 등록](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) 및 [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0) 이벤트 참조).

**어시스턴트를 활성화하는 두 가지 방법:**

**1. 자동 구성 (권장):**

새로운 쉘 창을 열 때마다 Fount 어시스턴트가 자동으로 시작되고 도움을 제공하도록 하려면 이 명령을 사용하십시오:

```powershell
Install-FountAssist <Fount 사용자 이름> <필요한 역할 이름>
```

`<Fount 사용자 이름>` 및 `<필요한 역할 이름>`을 실제 Fount 사용자 이름 및 역할 이름으로 바꾸십시오.

**2. 수동 구성 (고급 사용자용):**

수동으로 설정하려면 다음 코드를 **쉘 프로필** 파일에 추가할 수 있습니다:

```powershell
Set-FountAssist <Fount 사용자 이름> <필요한 역할 이름>
```

## 어시스턴트는 언제 나타납니까?

Fount 어시스턴트는 다음 상황에서 자동으로 나타납니다:

- **잘못된 명령을 입력했을 때** (예: 철자 오류).
- **실행한 명령이 실패했을 때** (`$?` 값이 false).
- **`f` 명령을 적극적으로 사용할 때**

## 자동 어시스턴트 비활성화/활성화

`f` 명령을 사용하여 자동 어시스턴트 기능을 쉽게 비활성화하거나 활성화할 수 있습니다:

```powershell
f 0    # 자동 어시스턴트 비활성화 (f false / f no / f n / f disable / f unset / f off 등으로도 가능)
f 1    # 자동 어시스턴트 활성화 (f true / f yes / f y / f enable / f set / f on 등으로도 가능)
```
