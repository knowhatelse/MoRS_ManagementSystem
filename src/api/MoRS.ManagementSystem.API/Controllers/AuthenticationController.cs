using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.Authentication;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Interfaces.Services;

namespace MoRS.ManagementSystem.API.Controllers;

[Route("api/[controller]")]
[ApiController]
public class AuthenticationController(IAuthenticationService service) : ControllerBase
{
    private readonly IAuthenticationService _service = service;

    [HttpPost]
    public async Task<ActionResult<UserResponse>> Login([FromBody] LoginRequest request)
    {
        try
        {
            var result = await _service.LoginAsync(request);
            return Ok(result);
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { message = "Neispravna email adresa ili lozinka" });
        }
        catch (Exception)
        {
            return StatusCode(500, new { message = "Došlo je do greške prilikom prijave" });
        }
    }
}
