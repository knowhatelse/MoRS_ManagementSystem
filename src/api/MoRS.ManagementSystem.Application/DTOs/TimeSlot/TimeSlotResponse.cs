namespace MoRS.ManagementSystem.Application.DTOs.TimeSlot;

public class TimeSlotResponse
{
    public int Id { get; set; }

    public TimeSpan TimeFrom { get; set; }
    public TimeSpan TimeTo { get; set; }
}
