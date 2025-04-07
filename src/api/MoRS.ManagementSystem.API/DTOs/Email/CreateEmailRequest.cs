namespace MoRS.ManagementSystem.API.DTOs.Email;

public class CreateEmailRequest
{
    public required string Subject { get; set; }
    public required string Body { get; set; }

    public List<int> UserIds { get; set; } = null!;
}
