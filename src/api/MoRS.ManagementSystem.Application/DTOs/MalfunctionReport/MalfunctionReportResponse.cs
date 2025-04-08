using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.DTOs.User;

namespace MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;

public class MalfunctionReportResponse
{
    public int Id { get; set; }
    public required string Description { get; set; }
    public DateTime Date { get; set; }
    public RoomResponse? Room { get; set; }
    public UserResponse? ReportedByUser { get; set; }
}
