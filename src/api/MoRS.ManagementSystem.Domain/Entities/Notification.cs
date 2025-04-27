using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Notification
{
    public int Id { get; set; }

    public required string Title { get; set; }
    public required string Message { get; set; }
    public NotificationType Type { get; set; }
    public DateTime Date { get; set; } = DateTime.Now;
    public bool IsRead { get; set; } = false;

    public int UserId { get; set; }
    public User User { get; set; } = null!;
}
