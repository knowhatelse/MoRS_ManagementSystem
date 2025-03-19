using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Notification
{
    [Key]
    public int Id { get; set; }
    public required string Title { get; set; }
    public required string Message { get; set; }
    public required string Type { get; set; }
    public DateTime Date { get; set; }
    public bool IsRead { get; set; }
}
