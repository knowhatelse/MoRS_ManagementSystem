using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class AppointmentSchedule
{
    [Key]
    public int Id { get; set; }
    public DateOnly Date { get; set; }
}
