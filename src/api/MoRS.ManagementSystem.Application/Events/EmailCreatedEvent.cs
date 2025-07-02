namespace MoRS.ManagementSystem.Application.Events;

public class EmailCreatedEvent
{
    public string? Subject { get; set; }
    public string? Body { get; set; }
    public List<string>? UserEmails { get; set; }
}

