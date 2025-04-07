using MoRS.ManagementSystem.API.DTOs.AppointmentSchedule;

namespace MoRS.ManagementSystem.API.DTOs.Appointment;

public class CreateAppointmentRequest
{
    public bool IsRepeating { get; set; }
    public CreateAppointmentScheduleRequest? AppointmentSchedule { get; set; }
    public int RoomId { get; set; }
    public int AppointmentTypeId { get; set; }
    public int? BookedByUserId { get; set; }
    public List<int>? AttendeesIds { get; set; }
}
