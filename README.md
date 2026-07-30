# WEBSITE QUẢN LÝ NHÀ HÀNG – ASP.NET CORE MVC

Dự án được xây dựng theo yêu cầu của báo cáo **“Xây dựng website quản lý nhà hàng”**:

- ASP.NET Core MVC, C# và Razor View.
- Entity Framework Core **Code First** với SQL Server.
- Cookie Authentication, phân quyền theo vai trò.
- Quản lý danh mục, món ăn, ảnh món ăn, bàn, khách hàng, đặt bàn, gọi món, hóa đơn, tài khoản và thống kê.
- Kiểm tra trùng lịch đặt bàn, chốt đơn giá tại thời điểm gọi món và thanh toán bằng transaction.
- Dữ liệu mẫu được seed tự động khi chạy lần đầu.

## 1. Yêu cầu

- Visual Studio 2022 có workload **ASP.NET and web development**.
- .NET 8 SDK.
- SQL Server Express/Developer hoặc LocalDB.

> Dự án dùng .NET 8 để tương thích tốt với Visual Studio 2022 và môi trường học tập. Có thể nâng package EF Core lên bản vá 8.x mới hơn sau khi mở dự án.

## 2. Mở và chạy nhanh trong Visual Studio

1. Mở file `RestaurantManager.sln` bằng Visual Studio.
2. Kiểm tra chuỗi kết nối trong `appsettings.json`.
3. Mở **Tools → NuGet Package Manager → Package Manager Console**.
4. Chạy:

```powershell
Add-Migration InitialCreate
Update-Database
```

5. Nhấn `Ctrl + F5` để chạy.

Ứng dụng có cơ chế dự phòng `EnsureCreated()` khi chưa có migration nên có thể tạo database trong lần chạy đầu. Tuy nhiên, để đúng quy trình Code First và theo dõi thay đổi cấu trúc, nên tạo migration bằng hai lệnh trên.

## 3. Chạy bằng Terminal

```bash
dotnet restore
dotnet tool install --global dotnet-ef --version 8.0.29
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet run
```

Có thể chạy `setup-database.cmd` hoặc `setup-database.ps1` trong thư mục dự án.

## 4. Tài khoản mẫu

Tất cả tài khoản mẫu dùng mật khẩu: `123456`

| Tên đăng nhập | Vai trò |
|---|---|
| `admin` | Quản trị viên |
| `quanly` | Quản lý |
| `phucvu01` | Nhân viên phục vụ |
| `thungan01` | Thu ngân |
| `khoa01` | Tài khoản bị khóa để kiểm thử |

Nên đổi mật khẩu ngay sau lần đăng nhập đầu tiên.

## 5. Phân quyền chính

- **Quản trị viên:** tài khoản, phân quyền, xem dữ liệu quản lý.
- **Quản lý:** danh mục, món ăn, bàn, khách hàng, đặt bàn, gọi món, thanh toán và báo cáo.
- **Nhân viên phục vụ:** bàn, khách hàng, đặt bàn và gọi món.
- **Thu ngân:** xem bàn/khách hàng, thanh toán và tra cứu hóa đơn.
- **Khách công khai:** xem thực đơn và gửi yêu cầu đặt bàn.

## 6. Cấu trúc dự án

```text
RestaurantManager/
├── Controllers/          # Nhận request và kiểm tra quyền
├── Data/                 # AppDbContext, DbSeeder
├── Models/               # Entity và enum trạng thái
├── Services/             # Nghiệp vụ đặt bàn, gọi món, thanh toán, báo cáo
├── ViewModels/           # Model dành cho biểu mẫu và báo cáo
├── Views/                # Razor View
├── wwwroot/              # CSS, JavaScript, ảnh upload
├── Program.cs            # DI, middleware, authentication, routing
└── appsettings.json      # Connection string
```

## 7. Cơ sở dữ liệu Code First

Các bảng chính:

- `VaiTro`
- `NguoiDung`
- `KhachHang`
- `BanAn`
- `DanhMucMonAn`
- `MonAn`
- `DatBan`
- `DonGoiMon`
- `ChiTietDonGoiMon`
- `HoaDon`

Ràng buộc được cấu hình trong `Data/AppDbContext.cs` bằng Fluent API: khóa chính, khóa ngoại, unique index, check constraint, decimal precision, enum-to-string và delete behavior.

## 8. Quy tắc nghiệp vụ đã cài đặt

- Không cho đặt cùng một bàn khi hai khoảng thời gian còn hiệu lực giao nhau.
- Số người không vượt quá sức chứa của bàn.
- Một bàn chỉ có tối đa một đơn đang phục vụ/chờ thanh toán.
- Món ngừng kinh doanh không được thêm vào đơn mới.
- Đơn giá được chốt khi thêm món; thành tiền bằng số lượng × đơn giá.
- Đơn phải có ít nhất một món chưa hủy trước khi chốt thanh toán.
- Một đơn chỉ có một hóa đơn.
- Thanh toán cập nhật đồng thời hóa đơn, trạng thái đơn và trạng thái bàn trong transaction.
- Doanh thu chỉ tính hóa đơn có trạng thái đã thanh toán.
- Không cho khóa hoặc hạ quyền quản trị viên cuối cùng đang hoạt động.

## 9. Đổi SQL Server

Ví dụ SQL Server Express:

```json
"DefaultConnection": "Server=.\\SQLEXPRESS;Database=RestaurantManagerDb;Trusted_Connection=True;TrustServerCertificate=True;MultipleActiveResultSets=true"
```

Ví dụ đăng nhập SQL Server:

```json
"DefaultConnection": "Server=localhost;Database=RestaurantManagerDb;User Id=sa;Password=YourPassword;TrustServerCertificate=True;MultipleActiveResultSets=true"
```

Không đưa mật khẩu thật lên Git; nên dùng User Secrets hoặc biến môi trường trong môi trường triển khai.

## 10. Ghi chú

Môi trường tạo mã nguồn hiện tại không có .NET SDK nên chưa thể chạy `dotnet build` trực tiếp. Mã nguồn đã được kiểm tra cấu trúc tệp, quan hệ entity và luồng nghiệp vụ; sau khi mở trong Visual Studio, hãy chạy Restore, tạo migration và Build để xác nhận theo cấu hình SQL Server trên máy của bạn.
