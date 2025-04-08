namespace MoRS.ManagementSystem.Application.DTOs.Room;

public class CreateRoomRequest
{
    public required string Name { get; set; }
    public required string Type { get; set; }
    public required string Color { get; set; }
}
