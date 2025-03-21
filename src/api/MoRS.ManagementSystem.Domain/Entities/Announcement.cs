namespace MoRS.ManagementSystem.Domain.Entities;

public class Announcement
{
    public int Id { get; set; }
    
    public required string Title { get; set; }
    public required string Content { get; set; }
    public DateTime CreatedAt { get; set; }
    public bool IsDeleted { get; set; }

    public int CreatedByUserId { get; set; }
    public User CreatedByUser { get; set; } = null!;
}
