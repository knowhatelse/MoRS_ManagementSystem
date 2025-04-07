namespace MoRS.ManagementSystem.API.DTOs.User;

public class CreateUserRequest
{
    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Email { get; set; }
    public required string PhoneNumber { get; set; }
    public int RoleId { get; set; }
}
