using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.DTOs.Role;

namespace MoRS.ManagementSystem.Application.DTOs.User;

public class UserResponse
{
    public int Id { get; set; }

    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Email { get; set; }
    public required string PhoneNumber { get; set; }
    public bool IsRestricted { get; set; }
    public ProfilePictureResponse? ProfilePicture { get; set; }
    public RoleResponse? Role { get; set; }
}
