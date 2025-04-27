using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.User;

public class UpdateUserRequest
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
    [RegularExpression(@"^(\+387|00387)?\s?6[0-9]\s?\d{3}\s?\d{3,4}$")]
    public required string PhoneNumber { get; set; }

    [Required]
    [StringLength(100, MinimumLength = 6)]
    [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$")]
    public required string Password { get; set; }

    [Required]
    public bool IsRestricted { get; set; }

    [Key]
    public int RoleId { get; set; }
}
