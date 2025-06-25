using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.User;

public class CreateUserRequest
{
    [Required]
    [StringLength(50, MinimumLength = 2)]
    public required string Name { get; set; }

    [Required]
    [StringLength(50, MinimumLength = 2)]
    public required string Surname { get; set; }

    [Required]
    [EmailAddress]
    [RegularExpression(@"^[^@\s]+@[^@\s]+\.[^@\s]+$")]

    public required string Email { get; set; }
    [Required]
    [RegularExpression(@"^(\+387|00387)?\s?0?6[0-9]\s?\d{3}\s?\d{3,4}$")]
    public required string PhoneNumber { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int RoleId { get; set; }
}
