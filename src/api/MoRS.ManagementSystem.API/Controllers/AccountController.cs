using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Infrastructure.Identity;
using MoRS.ManagementSystem.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AccountController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly MoRSManagementSystemDbContext _dbContext;

    public AccountController(UserManager<ApplicationUser> userManager, MoRSManagementSystemDbContext dbContext)
    {
        _userManager = userManager;
        _dbContext = dbContext;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest model)
    {
        try
        {
            var existingUserWithPhone = await _dbContext.Set<MoRS.ManagementSystem.Domain.Entities.User>()
                .AnyAsync(u => u.PhoneNumber == model.PhoneNumber);
            if (existingUserWithPhone)
            {
                return BadRequest(new { message = "User with this phone number already exists." });
            }

            string formattedName = string.IsNullOrWhiteSpace(model.Name) ? "User" : char.ToUpper(model.Name[0]) + model.Name.Substring(1).ToLowerInvariant();
            string formattedSurname = string.IsNullOrWhiteSpace(model.Surname) ? "User" : char.ToUpper(model.Surname[0]) + model.Surname.Substring(1).ToLowerInvariant();
            var password = $"{formattedName}.{formattedSurname}1";

            var user = new ApplicationUser
            {
                UserName = model.Email,
                Email = model.Email,
                Name = model.Name,
                Surname = model.Surname,
                PhoneNumber = model.PhoneNumber
            };

            var result = await _userManager.CreateAsync(user, password);

            if (!result.Succeeded)
            {
                var errors = result.Errors.Select(e => e.Description).ToList();
                var errorMessage = string.Join("; ", errors);
                return BadRequest(new { message = errorMessage, errors = errors });
            }
            var domainUser = new MoRS.ManagementSystem.Domain.Entities.User
            {
                Id = user.Id,
                Name = model.Name,
                Surname = model.Surname,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber,
                RoleId = model.RoleId,
                ProfilePicture = null,
                IsRestricted = false,
            };
            _dbContext.Set<MoRS.ManagementSystem.Domain.Entities.User>().Add(domainUser);

            await _dbContext.SaveChangesAsync();
            return Ok(new { generatedPassword = password });
        }
        catch (Exception ex)
        {
            return BadRequest($"Exception: {ex.Message}");
        }
    }
}

public class RegisterRequest
{
    public string Name { get; set; } = string.Empty;
    public string Surname { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public int RoleId { get; set; }
    public string Password { get; set; } = string.Empty;
}
