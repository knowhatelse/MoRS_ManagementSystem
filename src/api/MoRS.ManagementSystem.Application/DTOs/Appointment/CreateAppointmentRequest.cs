using System.ComponentModel.DataAnnotations;
using MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;

namespace MoRS.ManagementSystem.Application.DTOs.Appointment;

public class CreateAppointmentRequest
{
    [Required]
    public bool IsRepeating { get; set; }

    [Required]
    public CreateAppointmentScheduleRequest? AppointmentSchedule { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int RoomId { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int AppointmentTypeId { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int BookedByUserId { get; set; }

    public List<int>? AttendeesIds { get; set; }
}
