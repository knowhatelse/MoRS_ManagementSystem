namespace MoRS.ManagementSystem.Domain.Entities;

public class Room
{
    public int Id { get; set; }

    public required string Name { get; set; }
    public required string Type { get; set; }
    public required string Color { get; set; }
    public bool IsActive { get; set; } = true;

    public ICollection<Appointment> Appointments { get; set; } = [];
    public ICollection<MalfunctionReport> MalfunctionReports { get; set; } = [];
}
