using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MoRS.ManagementSystem.API.Controllers;

[Authorize]
[ApiController]
[Route("api/[controller]")]
public class ProtectedController : ControllerBase
{
    [HttpGet]
    public IActionResult GetSecret()
    {
        return Ok(new { message = "This is protected data!" });
    }
}
