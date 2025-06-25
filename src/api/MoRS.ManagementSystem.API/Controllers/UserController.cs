using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController(IUserService service)
    : BaseController<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>(service)
{
    private readonly IUserService _userService = service;

    [HttpPut("{id}/password")]
    public async Task<IActionResult> UpdatePassword(int id, [FromBody] UpdatePasswordRequest request)
    {
        try
        {
            var result = await _userService.UpdatePasswordAsync(id, request);
            if (!result)
            {
                return NotFound("User not found");
            }
            return Ok("Password updated successfully");
        }
        catch (Exception ex)
        {
            return BadRequest($"Error updating password: {ex.Message}");
        }
    }
}
