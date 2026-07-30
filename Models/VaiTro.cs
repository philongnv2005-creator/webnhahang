using System.ComponentModel.DataAnnotations;

namespace RestaurantManager.Models;

public class VaiTro
{
    [Key]
    public int MaVaiTro { get; set; }

    [Required, StringLength(50)]
    [Display(Name = "Tên vai trò")]
    public string TenVaiTro { get; set; } = string.Empty;

    [StringLength(255)]
    [Display(Name = "Mô tả")]
    public string? MoTa { get; set; }

    public ICollection<NguoiDung> NguoiDungs { get; set; } = new List<NguoiDung>();
}
