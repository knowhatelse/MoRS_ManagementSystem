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
        var result = await _service.LoginAsync(request);
        return result is not null ? Ok(result) : Unauthorized();
    }
}
