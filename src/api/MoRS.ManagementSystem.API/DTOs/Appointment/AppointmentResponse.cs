using MoRS.ManagementSystem.API.DTOs.AppointmentSchedule;
using MoRS.ManagementSystem.API.DTOs.AppointmentType;
using MoRS.ManagementSystem.API.DTOs.Room;
using MoRS.ManagementSystem.API.DTOs.User;

namespace MoRS.ManagementSystem.API.DTOs.Appointment;

public class AppointmentResponse
{
    public int Id { get; set; }
    public required AppointmentTypeResponse AppointmentType { get; set; }
    public required RoomResponse Room { get; set; }
    public required AppointmentScheduleResponse AppointmentSchedule { get; set; }
    public List<UserResponse> Attendees { get; set; } = [];
    public int UserId { get; set; }
}
