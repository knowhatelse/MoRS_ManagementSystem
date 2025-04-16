using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.Email;

public class CreateEmailRequest
{
    [Required]
    [StringLength(100, MinimumLength = 5)]
    public required string Subject { get; set; }

    [Required]
    [StringLength(2000, MinimumLength = 10)]
    public required string Body { get; set; }

    [Required]
    [MinLength(1)]
    public List<int> UserIds { get; set; } = null!;
}
