IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [BanAn] (
    [MaBan] int NOT NULL IDENTITY,
    [TenBan] nvarchar(50) NOT NULL,
    [KhuVuc] nvarchar(50) NOT NULL,
    [SoCho] int NOT NULL,
    [TrangThai] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_BanAn] PRIMARY KEY ([MaBan]),
    CONSTRAINT [CK_BanAn_SoCho] CHECK ([SoCho] > 0)
);
GO

CREATE TABLE [DanhMucMonAn] (
    [MaDanhMuc] int NOT NULL IDENTITY,
    [TenDanhMuc] nvarchar(100) NOT NULL,
    [MoTa] nvarchar(255) NULL,
    [TrangThai] bit NOT NULL,
    CONSTRAINT [PK_DanhMucMonAn] PRIMARY KEY ([MaDanhMuc])
);
GO

CREATE TABLE [KhachHang] (
    [MaKhachHang] int NOT NULL IDENTITY,
    [HoTen] nvarchar(100) NOT NULL,
    [SoDienThoai] nvarchar(15) NOT NULL,
    [DiaChi] nvarchar(255) NULL,
    [GhiChu] nvarchar(255) NULL,
    CONSTRAINT [PK_KhachHang] PRIMARY KEY ([MaKhachHang]),
    CONSTRAINT [CK_KhachHang_SoDienThoai] CHECK (LEN([SoDienThoai]) BETWEEN 9 AND 15)
);
GO

CREATE TABLE [VaiTro] (
    [MaVaiTro] int NOT NULL IDENTITY,
    [TenVaiTro] nvarchar(50) NOT NULL,
    [MoTa] nvarchar(255) NULL,
    CONSTRAINT [PK_VaiTro] PRIMARY KEY ([MaVaiTro])
);
GO

CREATE TABLE [MonAn] (
    [MaMon] int NOT NULL IDENTITY,
    [TenMon] nvarchar(100) NOT NULL,
    [DonGia] decimal(18,2) NOT NULL,
    [MoTa] nvarchar(500) NULL,
    [HinhAnh] nvarchar(255) NULL,
    [MaDanhMuc] int NOT NULL,
    [TrangThai] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_MonAn] PRIMARY KEY ([MaMon]),
    CONSTRAINT [CK_MonAn_DonGia] CHECK ([DonGia] > 0),
    CONSTRAINT [FK_MonAn_DanhMucMonAn_MaDanhMuc] FOREIGN KEY ([MaDanhMuc]) REFERENCES [DanhMucMonAn] ([MaDanhMuc]) ON DELETE NO ACTION
);
GO

CREATE TABLE [DatBan] (
    [MaDatBan] int NOT NULL IDENTITY,
    [MaKhachHang] int NOT NULL,
    [MaBan] int NOT NULL,
    [ThoiGianBatDau] datetime2 NOT NULL,
    [ThoiGianKetThuc] datetime2 NOT NULL,
    [SoNguoi] int NOT NULL,
    [TrangThai] nvarchar(30) NOT NULL,
    [GhiChu] nvarchar(255) NULL,
    CONSTRAINT [PK_DatBan] PRIMARY KEY ([MaDatBan]),
    CONSTRAINT [CK_DatBan_SoNguoi] CHECK ([SoNguoi] > 0),
    CONSTRAINT [CK_DatBan_ThoiGian] CHECK ([ThoiGianKetThuc] > [ThoiGianBatDau]),
    CONSTRAINT [FK_DatBan_BanAn_MaBan] FOREIGN KEY ([MaBan]) REFERENCES [BanAn] ([MaBan]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DatBan_KhachHang_MaKhachHang] FOREIGN KEY ([MaKhachHang]) REFERENCES [KhachHang] ([MaKhachHang]) ON DELETE NO ACTION
);
GO

CREATE TABLE [NguoiDung] (
    [MaNguoiDung] int NOT NULL IDENTITY,
    [TenDangNhap] nvarchar(50) NOT NULL,
    [MatKhauHash] nvarchar(255) NOT NULL,
    [HoTen] nvarchar(100) NOT NULL,
    [MaVaiTro] int NOT NULL,
    [TrangThai] bit NOT NULL,
    CONSTRAINT [PK_NguoiDung] PRIMARY KEY ([MaNguoiDung]),
    CONSTRAINT [FK_NguoiDung_VaiTro_MaVaiTro] FOREIGN KEY ([MaVaiTro]) REFERENCES [VaiTro] ([MaVaiTro]) ON DELETE NO ACTION
);
GO

CREATE TABLE [DonGoiMon] (
    [MaDon] int NOT NULL IDENTITY,
    [MaBan] int NOT NULL,
    [MaKhachHang] int NULL,
    [MaNhanVien] int NOT NULL,
    [NgayTao] datetime2 NOT NULL,
    [TrangThai] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_DonGoiMon] PRIMARY KEY ([MaDon]),
    CONSTRAINT [FK_DonGoiMon_BanAn_MaBan] FOREIGN KEY ([MaBan]) REFERENCES [BanAn] ([MaBan]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DonGoiMon_KhachHang_MaKhachHang] FOREIGN KEY ([MaKhachHang]) REFERENCES [KhachHang] ([MaKhachHang]) ON DELETE SET NULL,
    CONSTRAINT [FK_DonGoiMon_NguoiDung_MaNhanVien] FOREIGN KEY ([MaNhanVien]) REFERENCES [NguoiDung] ([MaNguoiDung]) ON DELETE NO ACTION
);
GO

CREATE TABLE [ChiTietDonGoiMon] (
    [MaChiTiet] int NOT NULL IDENTITY,
    [MaDon] int NOT NULL,
    [MaMon] int NOT NULL,
    [SoLuong] int NOT NULL,
    [DonGia] decimal(18,2) NOT NULL,
    [ThanhTien] decimal(18,2) NOT NULL,
    [TrangThaiMon] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_ChiTietDonGoiMon] PRIMARY KEY ([MaChiTiet]),
    CONSTRAINT [CK_ChiTietDon_DonGia] CHECK ([DonGia] > 0),
    CONSTRAINT [CK_ChiTietDon_SoLuong] CHECK ([SoLuong] > 0),
    CONSTRAINT [CK_ChiTietDon_ThanhTien] CHECK ([ThanhTien] >= 0),
    CONSTRAINT [FK_ChiTietDonGoiMon_DonGoiMon_MaDon] FOREIGN KEY ([MaDon]) REFERENCES [DonGoiMon] ([MaDon]) ON DELETE CASCADE,
    CONSTRAINT [FK_ChiTietDonGoiMon_MonAn_MaMon] FOREIGN KEY ([MaMon]) REFERENCES [MonAn] ([MaMon]) ON DELETE NO ACTION
);
GO

CREATE TABLE [HoaDon] (
    [MaHoaDon] int NOT NULL IDENTITY,
    [MaDon] int NOT NULL,
    [MaNhanVien] int NOT NULL,
    [NgayThanhToan] datetime2 NOT NULL,
    [TongTien] decimal(18,2) NOT NULL,
    [GiamGia] decimal(18,2) NOT NULL,
    [ThanhTien] decimal(18,2) NOT NULL,
    [PhuongThuc] nvarchar(50) NOT NULL,
    [TrangThai] nvarchar(30) NOT NULL,
    CONSTRAINT [PK_HoaDon] PRIMARY KEY ([MaHoaDon]),
    CONSTRAINT [CK_HoaDon_GiamGia] CHECK ([GiamGia] >= 0 AND [GiamGia] <= [TongTien]),
    CONSTRAINT [CK_HoaDon_ThanhTien] CHECK ([ThanhTien] >= 0),
    CONSTRAINT [CK_HoaDon_TongTien] CHECK ([TongTien] >= 0),
    CONSTRAINT [FK_HoaDon_DonGoiMon_MaDon] FOREIGN KEY ([MaDon]) REFERENCES [DonGoiMon] ([MaDon]) ON DELETE NO ACTION,
    CONSTRAINT [FK_HoaDon_NguoiDung_MaNhanVien] FOREIGN KEY ([MaNhanVien]) REFERENCES [NguoiDung] ([MaNguoiDung]) ON DELETE NO ACTION
);
GO

CREATE UNIQUE INDEX [IX_BanAn_TenBan] ON [BanAn] ([TenBan]);
GO

CREATE INDEX [IX_ChiTietDonGoiMon_MaDon_MaMon] ON [ChiTietDonGoiMon] ([MaDon], [MaMon]);
GO

CREATE INDEX [IX_ChiTietDonGoiMon_MaMon] ON [ChiTietDonGoiMon] ([MaMon]);
GO

CREATE UNIQUE INDEX [IX_DanhMucMonAn_TenDanhMuc] ON [DanhMucMonAn] ([TenDanhMuc]);
GO

CREATE INDEX [IX_DatBan_MaBan_ThoiGianBatDau_ThoiGianKetThuc] ON [DatBan] ([MaBan], [ThoiGianBatDau], [ThoiGianKetThuc]);
GO

CREATE INDEX [IX_DatBan_MaKhachHang] ON [DatBan] ([MaKhachHang]);
GO

CREATE INDEX [IX_DonGoiMon_MaBan_TrangThai] ON [DonGoiMon] ([MaBan], [TrangThai]);
GO

CREATE INDEX [IX_DonGoiMon_MaKhachHang] ON [DonGoiMon] ([MaKhachHang]);
GO

CREATE INDEX [IX_DonGoiMon_MaNhanVien] ON [DonGoiMon] ([MaNhanVien]);
GO

CREATE UNIQUE INDEX [IX_HoaDon_MaDon] ON [HoaDon] ([MaDon]);
GO

CREATE INDEX [IX_HoaDon_MaNhanVien] ON [HoaDon] ([MaNhanVien]);
GO

CREATE INDEX [IX_HoaDon_NgayThanhToan] ON [HoaDon] ([NgayThanhToan]);
GO

CREATE INDEX [IX_KhachHang_SoDienThoai] ON [KhachHang] ([SoDienThoai]);
GO

CREATE INDEX [IX_MonAn_MaDanhMuc_TenMon] ON [MonAn] ([MaDanhMuc], [TenMon]);
GO

CREATE INDEX [IX_NguoiDung_MaVaiTro] ON [NguoiDung] ([MaVaiTro]);
GO

CREATE UNIQUE INDEX [IX_NguoiDung_TenDangNhap] ON [NguoiDung] ([TenDangNhap]);
GO

CREATE UNIQUE INDEX [IX_VaiTro_TenVaiTro] ON [VaiTro] ([TenVaiTro]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260721140936_InitialCreate', N'8.0.29');
GO

COMMIT;
GO

