using System.ComponentModel.DataAnnotations;
using MoRS.ManagementSystem.Application.DTOs.TimeSlot;

namespace MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;

public class CreateAppointmentScheduleRequest
{
    [Required]
    public DateOnly Date { get; set; }
    
    [Required]
    public CreateTimeSlotRequest? Time { get; set; } = null!;
}
