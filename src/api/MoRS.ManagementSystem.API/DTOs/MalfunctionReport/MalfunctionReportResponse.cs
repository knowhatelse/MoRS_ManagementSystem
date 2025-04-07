using MoRS.ManagementSystem.API.DTOs.Room;
using MoRS.ManagementSystem.API.DTOs.User;

namespace MoRS.ManagementSystem.API.DTOs.MalfunctionReport;

public class MalfunctionReportResponse
{
    public int Id { get; set; }
    public required string Description { get; set; }
    public DateTime Date { get; set; }
    public RoomResponse? Room { get; set; } 
    public UserResponse? ReportedByUser { get; set; } 
}
