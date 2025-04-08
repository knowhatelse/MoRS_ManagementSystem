using MoRS.ManagementSystem.Application.DTOs.User;

namespace MoRS.ManagementSystem.Application.DTOs.Email;

public class EmailResponse
{
    public required string Subject { get; set; }
    public required string Body { get; set; }
    public List<UserResponse>? Users { get; set; }
}
