namespace MoRS.ManagementSystem.Application.Filters;

public class MalfunctionReportQuery
{
    public int? RoomId { get; set; }
    public int? UserId { get; set; }
    public DateOnly? Date { get; set; }
    
    public bool IsRoomIncluded { get; set; } = true;
    public bool IsUserIncluded { get; set; } = true;
}
