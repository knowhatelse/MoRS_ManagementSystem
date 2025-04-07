using MoRS.ManagementSystem.API.DTOs.TimeSlot;

namespace MoRS.ManagementSystem.API.DTOs.AppointmentSchedule;

public class AppointmentScheduleResponse
{
    public int Id { get; set; }

    public DateOnly Date { get; set; }
    public required TimeSlotResponse Time { get; set; }
}
