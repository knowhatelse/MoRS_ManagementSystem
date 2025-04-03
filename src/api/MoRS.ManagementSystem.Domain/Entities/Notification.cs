using MoRS.ManagementSystem.Domain.Entities.Enums;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Notification
{
    public int Id { get; set; }

    public required string Title { get; set; }
    public required string Message { get; set; }
    public NotificationType Type { get; set; }
    public DateTime Date { get; set; }
    public bool IsRead { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;
}
