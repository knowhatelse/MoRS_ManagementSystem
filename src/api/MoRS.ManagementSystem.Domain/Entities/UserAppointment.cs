using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class UserAppointment
{
    [Key]
    public int Id { get; set; }
}
