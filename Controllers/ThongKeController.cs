using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RestaurantManager.Helpers;
using RestaurantManager.Services;

namespace RestaurantManager.Controllers;

[Authorize(Roles = RoleNames.QuanTriHoacQuanLy)]
public class ThongKeController : Controller
{
    private readonly IReportService _reportService;

    public ThongKeController(IReportService reportService) => _reportService = reportService;

    public async Task<IActionResult> Index(DateTime? from, DateTime? to)
    {
        var fromDate = from?.Date ?? DateTime.Today.AddDays(-30);
        var toDate = to?.Date ?? DateTime.Today;
        if (toDate < fromDate) (fromDate, toDate) = (toDate, fromDate);
        return View(await _reportService.GetReportAsync(fromDate, toDate));
    }
}
