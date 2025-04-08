namespace MoRS.ManagementSystem.Application.DTOs.Email;

public class CreateEmailRequest
{
    public required string Subject { get; set; }
    public required string Body { get; set; }

    public List<int> UserIds { get; set; } = null!;
}
