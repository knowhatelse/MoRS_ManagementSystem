using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.Room;

public class UpdateRoomRequest
{
    [Required]
    [StringLength(50, MinimumLength = 2)]
    public required string Name { get; set; }

    [Required]
    [StringLength(50, MinimumLength = 2)]
    public required string Type { get; set; }

    [Required]
    [RegularExpression("^#(?:[0-9a-fA-F]{3}){1,2}$")]
    public required string Color { get; set; }

    [Required]
    public bool IsActive { get; set; }
}
