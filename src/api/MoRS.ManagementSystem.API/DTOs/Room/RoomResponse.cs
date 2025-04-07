namespace MoRS.ManagementSystem.API.DTOs.Room;

public class RoomResponse
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Type { get; set; }
    public required string Color { get; set; }
    public bool IsActive { get; set; }
}
