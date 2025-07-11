namespace MoRS.ManagementSystem.Domain.Entities;

public class MalfunctionReport
{
    public int Id { get; set; }
    
    public required string Description { get; set; }
    public DateTime Date { get; set; } = DateTime.Now;
    public bool IsArchived { get; set; } = false;

    public int RoomId { get; set; }
    public Room Room { get; set; } = null!;

    public int ReportedByUserId { get; set; }
    public User ReportedByUser { get; set; } = null!;
}
