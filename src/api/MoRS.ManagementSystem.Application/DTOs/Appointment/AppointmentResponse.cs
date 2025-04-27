using MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;
using MoRS.ManagementSystem.Application.DTOs.AppointmentType;
using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.DTOs.User;

namespace MoRS.ManagementSystem.Application.DTOs.Appointment;

public class AppointmentResponse
{
    public int Id { get; set; }
    public required AppointmentTypeResponse AppointmentType { get; set; }
    public required RoomResponse Room { get; set; }
    public required AppointmentScheduleResponse AppointmentSchedule { get; set; }
    public List<UserResponse> Attendees { get; set; } = [];
    public UserResponse? BookedByUser { get; set; }
    public DateOnly OccuringDate { get; set; }
}
