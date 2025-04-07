using MoRS.ManagementSystem.API.DTOs.TimeSlot;

namespace MoRS.ManagementSystem.API.DTOs.AppointmentSchedule;

public class CreateAppointmentScheduleRequest
{
    public DateOnly Date { get; set; }
    public CreateTimeSlotRequest? Time { get; set; } = null!;
}
