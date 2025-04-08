namespace MoRS.ManagementSystem.Application.DTOs.Room;

public class UpdateRoomRequest
{
    public required string Type { get; set; }
    public required string Color { get; set; }
    public bool IsActive { get; set; }

}
