using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.AppointmentType;

public class CreateAppointmentTypeRequest
{
    [Required]
    [StringLength(50, MinimumLength = 2)]
    public required string Name { get; set; }
}
