using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.Announcement;

public class UpdateAnnouncementRequest
{
    [Required]
    [StringLength(100, MinimumLength = 5)]
    public required string Title { get; set; }

    [Required]
    [StringLength(2000, MinimumLength = 10)]
    public required string Content { get; set; }
    public bool IsDeleted { get; set; } = false;
}
