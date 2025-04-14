using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Utils;

public static class TimeSlotValidator
{
    public static bool IsValidTimeSlot(TimeSlot? existing, TimeSlot? incoming)
    {
        if (existing is null || incoming is null)
        {
            return false;
        }

        return incoming.TimeFrom < existing.TimeTo && existing.TimeFrom < incoming.TimeTo;
    }
}
