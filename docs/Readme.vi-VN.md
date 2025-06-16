# fount-pwsh

[![fount repo](https://steve02081504.github.io/fount/badges/fount_repo.svg)](https://github.com/steve02081504/fount)
[![PSGallery download num](https://img.shields.io/powershellgallery/dt/fount-pwsh)](https://www.powershellgallery.com/packages/fount-pwsh)

**fount-pwsh** là một công cụ cho phép bạn dễ dàng sử dụng [fount](https://github.com/steve02081504/fount) trong các terminal PowerShell hoặc esh.
Nó có thể giúp bạn sử dụng shell tốt hơn hoặc chỉ trò chuyện với các vai trò trong shell.

![Hình ảnh: ví dụ sử dụng fount-pwsh](https://github.com/user-attachments/assets/93afee48-93d4-42c7-a5e0-b7f5c93bdee9)

## Cài đặt

Sử dụng lệnh này để cài đặt mô-đun `fount-pwsh`:

```powershell
Install-Module fount-pwsh
```

**Lưu ý:** `fount-pwsh` dựa vào [fount](https://github.com/steve02081504/fount) để hoạt động.
Nhưng đừng lo lắng!
Nếu bạn chưa cài đặt fount, `fount-pwsh` sẽ **tự động cài đặt fount cho bạn** trong lần đầu tiên bạn sử dụng các lệnh sau:

- `Start-fount`
- `Set-FountAssist`
- `Install-FountAssist`

## Định cấu hình Trợ lý

> [!WARNING]
> **Giới thiệu về hiệu suất PowerShell**
>
> Trong PowerShell, việc tải một trợ lý fount mất trung bình **khoảng 600 mili giây**. Điều này có thể ảnh hưởng một chút đến tốc độ khởi động shell của bạn. (Đối với esh, việc tải là **tức thời**.)
>
> Nếu bạn muốn PowerShell khởi động nhanh hơn, bạn có thể xem xét đặt việc tải trợ lý fount thành **tải nền** (tham khảo [đăng ký sự kiện](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/register-engineevent?view=powershell-7.5) của PowerShell và sự kiện [OnIdle](https://learn.microsoft.com/dotnet/api/system.management.automation.psengineevent.onidle?view=powershellsdk-7.4.0)).

**Hai cách để bật trợ lý của bạn:**

**1. Cấu hình tự động (Khuyến nghị):**

Sử dụng lệnh này để trợ lý fount tự động khởi động và cung cấp hỗ trợ mỗi khi bạn mở một cửa sổ shell mới:

```powershell
Install-FountAssist <Tên người dùng fount của bạn> <Tên vai trò bắt buộc>
```

Thay thế `<Tên người dùng fount của bạn>` và `<Tên vai trò bắt buộc>` bằng tên người dùng fount thực tế và tên vai trò của bạn.

**2. Cấu hình thủ công (Dành cho người dùng nâng cao):**

Nếu bạn muốn thiết lập thủ công, bạn có thể thêm đoạn mã sau vào tệp **hồ sơ shell** của mình:

```powershell
Set-FountAssist <Tên người dùng fount của bạn> <Tên vai trò bắt buộc>
```

## Khi nào trợ lý xuất hiện?

Trợ lý fount sẽ tự động xuất hiện trong các tình huống sau:

- **Khi bạn nhập sai lệnh** (chẳng hạn như lỗi chính tả).
- **Khi một lệnh bạn chạy không thực thi được** (giá trị của `$?` là false).
- **Khi bạn chủ động sử dụng lệnh `f`**

## Tắt/Bật Trợ lý tự động

Bạn có thể sử dụng lệnh `f` để dễ dàng tắt hoặc bật tính năng trợ lý tự động:

```powershell
f 0    # Tắt trợ lý tự động (cũng có thể với f false / f no / f n / f disable / f unset / f off, v.v.)
f 1    # Bật trợ lý tự động (cũng có thể với f true / f yes / f y / f enable / f set / f on, v.v.)
```
