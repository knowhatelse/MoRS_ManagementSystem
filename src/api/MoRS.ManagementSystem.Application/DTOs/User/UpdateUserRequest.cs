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
    [RegularExpression(@"^06[0-9]{7,8}$", ErrorMessage = "Broj telefona mora počinjati sa 06 i imati ukupno 9 ili 10 cifara bez razmaka i specijalnih znakova.")]
    public required string PhoneNumber { get; set; }

    [Required]
    public bool IsRestricted { get; set; }

    [Key]
    public int RoleId { get; set; }
}
