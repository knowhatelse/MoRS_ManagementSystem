namespace MoRS.ManagementSystem.Domain.Entities;

public class TimeSlot
{
    public int Id { get; set; }

    public TimeSpan TimeFrom { get; set; }
    public TimeSpan TimeTo { get; set; }

    public int AppointmentScheduleId { get; set; }
    public AppointmentSchedule AppointmentSchedule { get; set; } = null!;
}
