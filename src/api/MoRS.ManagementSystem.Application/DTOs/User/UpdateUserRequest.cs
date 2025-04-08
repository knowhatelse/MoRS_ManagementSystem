namespace MoRS.ManagementSystem.Application.DTOs.User;

public class UpdateUserRequest
{
    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Email { get; set; }
    public required string PhoneNumber { get; set; }
    public required string Password { get; set; }
    public bool IsRestricted { get; set; }
    public int RoleId { get; set; }
}
