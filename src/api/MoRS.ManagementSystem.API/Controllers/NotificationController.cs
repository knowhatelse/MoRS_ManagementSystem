using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Notification;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class NotificationController(INotificationService service)
    : BaseController<Notification, NotificationResponse, EmptyDto, EmptyDto, NotificationQuery>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<NotificationResponse>> Add([FromBody] EmptyDto request) => base.Add(request);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<NotificationResponse>> Update(int id, EmptyDto request) => base.Update(id, request);
}
