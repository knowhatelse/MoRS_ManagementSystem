namespace MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;

public class CreateMalfunctionReportProfileRequest
{
    public required string Description { get; set; }
    public DateTime Date { get; set; }
    public int RoomId { get; set; }
    public int ReportedByUserId { get; set; }
}

