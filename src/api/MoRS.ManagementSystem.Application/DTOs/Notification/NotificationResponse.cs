using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.DTOs.Notification;

public class NotificationResponse
{
    public int Id { get; set; }

    public required string Title { get; set; }
    public required string Message { get; set; }
    public NotificationType Type { get; set; }
    public DateTime Date { get; set; } = DateTime.Now;
    public bool IsRead { get; set; } = false;
    public UserResponse User { get; set; } = null!;
}
