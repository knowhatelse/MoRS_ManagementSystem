using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Utils;

public static class TimeSlotValidator
{
    private static readonly TimeSpan AllowedStartTime = new(8, 0, 0);
    private static readonly TimeSpan AllowedEndTime = new(23, 59, 59);
    private static readonly TimeSpan MinimumDuration = new(0, 30, 0);
    private static readonly TimeSpan MaximumDuration = new(3, 0, 0);

    public static bool IsValidTimeSlot(TimeSlot? existing, TimeSlot? incoming)
    {
        if (existing is null || incoming is null)
        {
            return false;
        }

        return incoming.TimeFrom < existing.TimeTo && existing.TimeFrom < incoming.TimeTo;
    }
    public static bool IsOccurringOnDate(Appointment appointment, DateOnly date)
    {
        if (appointment.IsCancelled)
        {
            return false;
        }

        if (!appointment.IsRepeating)
        {
            return appointment.AppointmentSchedule?.Date == date;
        }

        var targetDayName = date.DayOfWeek.ToString();
        return appointment.AppointmentSchedule?.Date <= date &&
               !string.IsNullOrEmpty(appointment.DayOfOccurrance) &&
               appointment.DayOfOccurrance.Equals(targetDayName, StringComparison.OrdinalIgnoreCase);
    }

    public static bool IsWithinAllowedHours(TimeSlot timeSlot)
    {
        var endTime = timeSlot.TimeTo;
        if (endTime == TimeSpan.Zero)
        {
            endTime = new TimeSpan(24, 0, 0);
        }

        return timeSlot.TimeFrom >= AllowedStartTime &&
               endTime <= new TimeSpan(24, 0, 0) &&
               timeSlot.TimeFrom < endTime;
    }

    public static bool IsValidDuration(TimeSlot timeSlot)
    {
        if (timeSlot.TimeFrom >= timeSlot.TimeTo)
        {
            return false;
        }
        var duration = timeSlot.TimeTo - timeSlot.TimeFrom;

        if (duration < TimeSpan.Zero)
        {
            duration = duration.Add(new TimeSpan(24, 0, 0));
        }

        return duration >= MinimumDuration && duration <= MaximumDuration;
    }

    public static bool IsValidTimeRange(TimeSlot timeSlot)
    {
        return timeSlot.TimeFrom < timeSlot.TimeTo ||
               (timeSlot.TimeTo == TimeSpan.Zero && timeSlot.TimeFrom < new TimeSpan(24, 0, 0));
    }
}
