using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.AppointmentType;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;


[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AppointmentTypeController(IAppointmentTypeService service)
    : BaseController<AppointmentType, AppointmentTypeResponse, CreateAppointmentTypeRequest, EmptyDto, EmptyQuery>(service)
{

}
