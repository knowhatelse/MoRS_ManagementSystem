using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PaymentController(IPaymentService service)
    : BaseController<Payment, PaymentResponse, CreatePaymentRequest, EmptyDto, NoQuery, IPaymentService>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<IEnumerable<PaymentResponse>>> Get(NoQuery? queryFilter = null) => base.Get(queryFilter);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<PaymentResponse>> GetById(int id) => base.GetById(id);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<PaymentResponse>> Update(int id, EmptyDto request) => base.Update(id, request);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<IActionResult> Delete(int id) => base.Delete(id);
}
