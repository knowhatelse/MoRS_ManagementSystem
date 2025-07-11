namespace MoRS.ManagementSystem.Domain.Entities;

public class Email
{
    public int Id { get; set; }
    public required string Subject { get; set; }
    public required string Body { get; set; }

    public List<User> Users { get; set; } = [];
}
