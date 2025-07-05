using MoRS.ManagementSystem.Application.DTOs.User;

namespace MoRS.ManagementSystem.Application.DTOs.Announcement;

public class AnnouncementResponse
{
    public int Id { get; set; }
    public required string Title { get; set; }
    public required string Content { get; set; }
    public DateTime CreatedAt { get; set; }
    public UserResponse? User { get; set; }
}
