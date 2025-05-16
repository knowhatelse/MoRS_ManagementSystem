using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AnnouncementController(IAnnouncementService service)
    : BaseController<Announcement, AnnouncementResponse, CreateAnnouncementRequest, UpdateAnnouncementRequest, NoQuery, IAnnouncementService>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<IActionResult> Delete(int id) => base.Delete(id);
}
