namespace MoRS.ManagementSystem.Application.Filters;

public class AppointmentQuery
{
    public DateOnly? Date { get; set; }
    public DateOnly? DateFrom { get; set; }
    public DateOnly? DateTo { get; set; }
    public int? RoomId { get; set; }
    public int? BookedByUserId { get; set; }
    public int? AttendeeId { get; set; }
    public bool IsCancelled { get; set; } = false;
    public bool IsRepeating { get; set; } = true;

    public bool IsRoomIncluded { get; set; } = true;
    public bool IsAppointmentTypeIncluded { get; set; } = true;
    public bool IsAppointmentScheduleIncluded { get; set; } = true;
    public bool IsUserIncluded { get; set; } = true;
    public bool AreAttendeesIncluded { get; set; } = true;
}
