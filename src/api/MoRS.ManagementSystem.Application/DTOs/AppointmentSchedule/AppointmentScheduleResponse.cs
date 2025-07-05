using MoRS.ManagementSystem.Application.DTOs.TimeSlot;

namespace MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;

public class AppointmentScheduleResponse
{
    public int Id { get; set; }

    public DateOnly Date { get; set; }
    public required TimeSlotResponse Time { get; set; }
}
