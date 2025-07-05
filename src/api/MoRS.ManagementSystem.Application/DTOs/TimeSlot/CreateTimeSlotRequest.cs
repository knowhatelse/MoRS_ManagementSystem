using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.TimeSlot;

public class CreateTimeSlotRequest
{
    [Required]
    public TimeSpan TimeFrom { get; set; }
    
    [Required]
    public TimeSpan TimeTo { get; set; }
}
