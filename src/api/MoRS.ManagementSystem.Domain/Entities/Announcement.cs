namespace MoRS.ManagementSystem.Domain.Entities;

public class Announcement
{
    public int Id { get; set; }

    public required string Title { get; set; }
    public required string Content { get; set; }
    public DateTime CreatedAt { get; set; }
    public bool IsDeleted { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;
}
