namespace MoRS.ManagementSystem.Domain.Entities;

public class UserAppointment
{
    public int? UserId { get; set; }
    public int? AppointmentId { get; set; }
    
    public User? User { get; set; }
    public Appointment? Appointment { get; set; }
}
