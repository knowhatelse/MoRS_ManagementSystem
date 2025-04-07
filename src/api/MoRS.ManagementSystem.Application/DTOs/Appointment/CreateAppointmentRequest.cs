using MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;

namespace MoRS.ManagementSystem.Application.DTOs.Appointment;

public class CreateAppointmentRequest
{
    public bool IsRepeating { get; set; }
    public CreateAppointmentScheduleRequest? AppointmentSchedule { get; set; }
    public int RoomId { get; set; }
    public int AppointmentTypeId { get; set; }
    public int? BookedByUserId { get; set; }
    public List<int>? AttendeesIds { get; set; }
}
