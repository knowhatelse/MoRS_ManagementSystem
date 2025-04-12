namespace MoRS.ManagementSystem.Domain.Entities;

public class Appointment
{
    public int Id { get; set; }

    public bool IsRepeating { get; set; } = false;
    public bool IsCancelled { get; set; } = false;
    public AppointmentSchedule? AppointmentSchedule { get; set; }

    public int RoomId { get; set; }
    public Room Room { get; set; } = null!;

    public int AppointmentTypeId { get; set; }
    public AppointmentType AppointmentType { get; set; } = null!;

    public int? BookedByUserId { get; set; }
    public User BookedByUser { get; set; } = null!;

    public List<User> Attendees { get; set; } = [];
}
