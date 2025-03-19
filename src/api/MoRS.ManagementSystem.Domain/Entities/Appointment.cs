using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Appointment
{
    [Key]
    public int Id { get; set; }
    public bool IsRepeating { get; set; }
    public bool IsCancelled { get; set; }
}
