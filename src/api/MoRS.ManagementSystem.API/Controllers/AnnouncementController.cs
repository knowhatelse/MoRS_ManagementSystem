using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AnnouncementController(IAnnouncementService service)
    : BaseController<Announcement, AnnouncementResponse, CreateAnnouncementRequest, UpdateAnnouncementRequest, AnnouncementQuery>(service)
{

}
