using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AppointmentController(IAppointmentService service)
    : BaseController<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentQuery>(service)
{
}
