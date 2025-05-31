using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class EmailController(IEmailService service)
    : BaseController<Email, EmailResponse, CreateEmailRequest, EmptyDto, EmptyQuery>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<IEnumerable<EmailResponse>>> Get(EmptyQuery? queryFilter = null) => base.Get(queryFilter);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<EmailResponse>> GetById(int id) => base.GetById(id);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<EmailResponse>> Update(int id, EmptyDto request) => base.Update(id, request);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<IActionResult> Delete(int id) => base.Delete(id);
}
