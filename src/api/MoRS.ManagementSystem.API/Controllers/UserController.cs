using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Services;
using AutoMapper;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UserController : BaseController<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>
{
    private readonly IUserService _userService;
    private readonly UserManagementService _userManagementService;
    private readonly IMapper _mapper;

    public UserController(IUserService service, UserManagementService userManagementService, IMapper mapper)
        : base(service)
    {
        _userService = service;
        _userManagementService = userManagementService;
        _mapper = mapper;
    }

    [HttpPut("{id}/password")]
    public async Task<IActionResult> UpdatePassword(int id, [FromBody] UpdatePasswordRequest request)
    {
        try
        {
            var result = await _userManagementService.UpdatePasswordAsync(id, request.NewPassword);
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

    [HttpPut("/api/user/{id}")]
    public async Task<IActionResult> UpdateUser(int id, [FromBody] UpdateUserRequest request)
    {
        try
        {
            var updatedDomainUser = await _userManagementService.UpdateUserAsync(id, request);
            if (updatedDomainUser == null)
            {
                return NotFound("User not found");
            }

            var userResponse = _mapper.Map<UserResponse>(updatedDomainUser);
            return Ok(userResponse);
        }
        catch (Exception ex)
        {
            return BadRequest($"Error updating user: {ex.Message}");
        }
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        try
        {
            var result = await _userManagementService.DeleteUserAsync(id);
            if (!result)
            {
                return NotFound("User not found");
            }
            return Ok("User deleted successfully");
        }
        catch (Exception ex)
        {
            return BadRequest($"Error deleting user: {ex.Message}");
        }
    }

    [HttpGet("{id}")]
    public override async Task<ActionResult<UserResponse>> GetById(int id)
    {
        var domainUser = await _userService.GetByIdAsync(id);

        if (domainUser != null)
        {
            return Ok(domainUser);
        }
        var dbContext = HttpContext.RequestServices.GetService(typeof(MoRS.ManagementSystem.Infrastructure.Data.MoRSManagementSystemDbContext)) as MoRS.ManagementSystem.Infrastructure.Data.MoRSManagementSystemDbContext;

        if (dbContext != null)
        {
            var identityUser = dbContext.Users.FirstOrDefault(u => u.Id == id);
            if (identityUser != null)
            {
                var domainUserByEmail = dbContext.DomainUsers.FirstOrDefault(u => u.Email == identityUser.Email);

                if (domainUserByEmail != null)
                {
                    return Ok(domainUserByEmail);
                }
            }
        }

        return NotFound();
    }

    [NonAction]
    public override Task<IActionResult> Delete(int id)
    {
        throw new NotImplementedException();
    }

    [NonAction]
    public override Task<ActionResult<UserResponse>> Update(int id, UpdateUserRequest request)
    {
        throw new NotImplementedException();
    }
}
