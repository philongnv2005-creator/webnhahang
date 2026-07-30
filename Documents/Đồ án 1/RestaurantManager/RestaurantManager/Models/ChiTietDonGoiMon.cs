using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RestaurantManager.Models.Enums;

namespace RestaurantManager.Models;

public class ChiTietDonGoiMon
{
    [Key]
    public int MaChiTiet { get; set; }

    public int MaDon { get; set; }
    public int MaMon { get; set; }

    [Range(1, 999)]
    [Display(Name = "Số lượng")]
    public int SoLuong { get; set; } = 1;

    [Column(TypeName = "decimal(18,2)")]
    [Display(Name = "Đơn giá")]
    public decimal DonGia { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    [Display(Name = "Thành tiền")]
    public decimal ThanhTien { get; set; }

    [Display(Name = "Trạng thái món")]
    public TrangThaiMonTrongDon TrangThaiMon { get; set; } = TrangThaiMonTrongDon.ChoCheBien;

    public DonGoiMon? DonGoiMon { get; set; }
    public MonAn? MonAn { get; set; }
}
