namespace MoRS.ManagementSystem.Application.DTOs.TimeSlot;

public class CreateTimeSlotRequest
{
    public TimeSpan TimeFrom { get; set; }
    public TimeSpan TimeTo { get; set; }
}
