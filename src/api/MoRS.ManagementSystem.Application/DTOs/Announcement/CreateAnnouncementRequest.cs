namespace MoRS.ManagementSystem.Application.DTOs.Announcement;

public class CreateAnnouncementRequest
{
    public required string Title { get; set; }
    public required string Content { get; set; }
    public int UserId { get; set; }
}
