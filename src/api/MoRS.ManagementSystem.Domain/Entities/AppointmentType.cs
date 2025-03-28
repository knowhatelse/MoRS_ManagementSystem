namespace MoRS.ManagementSystem.Domain.Entities;

public class AppointmentType
{
    public int Id { get; set; }
    
    public required string Name { get; set; }

    public ICollection<Appointment> Appointments { get; set;} = [];
}
