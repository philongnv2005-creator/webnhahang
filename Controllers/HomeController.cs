using System.Diagnostics;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RestaurantManager.Data;
using RestaurantManager.Models.Enums;
using RestaurantManager.Services;

namespace RestaurantManager.Controllers;

public class HomeController : Controller
{
    private readonly AppDbContext _db;
    private readonly IReportService _reportService;

    public HomeController(AppDbContext db, IReportService reportService)
    {
        _db = db;
        _reportService = reportService;
    }

    [AllowAnonymous]
    public async Task<IActionResult> Index(string? q, int? categoryId)
    {
        var query = _db.MonAns
            .Include(x => x.DanhMucMonAn)
            .Where(x => x.TrangThai == TrangThaiMonAn.DangKinhDoanh && x.DanhMucMonAn!.TrangThai)
            .AsQueryable();

        if (!string.IsNullOrWhiteSpace(q))
        {
            query = query.Where(x => x.TenMon.Contains(q) || (x.MoTa != null && x.MoTa.Contains(q)));
        }

        if (categoryId.HasValue)
        {
            query = query.Where(x => x.MaDanhMuc == categoryId.Value);
        }

        ViewBag.Categories = await _db.DanhMucMonAns.Where(x => x.TrangThai).OrderBy(x => x.TenDanhMuc).ToListAsync();
        ViewBag.Query = q;
        ViewBag.CategoryId = categoryId;
        return View(await query.OrderBy(x => x.DanhMucMonAn!.TenDanhMuc).ThenBy(x => x.TenMon).ToListAsync());
    }

    [Authorize]
    public async Task<IActionResult> Dashboard()
    {
        return View(await _reportService.GetDashboardAsync());
    }

    [AllowAnonymous]
    public IActionResult Privacy() => View();

    [AllowAnonymous]
    public IActionResult Error()
    {
        ViewBag.RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier;
        return View();
    }
}
