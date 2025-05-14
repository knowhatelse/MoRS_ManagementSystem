using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.Authentication;

public class LoginRequest
{
    [Required]
    [EmailAddress]
    [RegularExpression(@"^[^@\s]+@[^@\s]+\.[^@\s]+$")]
    public required string Email { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    public required string Password { get; set; }
}
