using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.User;

public class UpdatePasswordRequest
{
    [Required]
    [StringLength(100, MinimumLength = 6)]
    public required string NewPassword { get; set; }
}
