using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.MembershipFee;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MembershipFeeController(IMembershipFeeService service)
    : BaseController<MembershipFee, MembershipFeeResponse, EmptyDto, EmptyDto, EmptyQuery>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<MembershipFeeResponse>> Add([FromBody] EmptyDto request) => base.Add(request);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<MembershipFeeResponse>> Update(int id, EmptyDto request) => base.Update(id, request);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<IActionResult> Delete(int id) => base.Delete(id);
}
