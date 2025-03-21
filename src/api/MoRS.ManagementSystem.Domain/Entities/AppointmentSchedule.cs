namespace MoRS.ManagementSystem.Domain.Entities;

public class AppointmentSchedule
{
    public int Id { get; set; }

    public DateOnly Date { get; set; }
    public Time? Time { get; set; } = null!;

    public int AppointmentId { get; set; }
    public Appointment Appointment { get; set; } = null!;
}
