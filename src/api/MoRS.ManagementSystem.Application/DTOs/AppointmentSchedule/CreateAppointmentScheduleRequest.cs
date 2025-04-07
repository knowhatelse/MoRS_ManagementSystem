using MoRS.ManagementSystem.Application.DTOs.TimeSlot;

namespace MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;

public class CreateAppointmentScheduleRequest
{
    public DateOnly Date { get; set; }
    public CreateTimeSlotRequest? Time { get; set; } = null!;
}
