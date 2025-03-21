namespace MoRS.ManagementSystem.Domain.Entities;

public class UserEmail
{
    public int UserId { get; set; }
    public int EmailId { get; set; }
    
    public User User { get; set; } = null!;
    public Email Email { get; set; } = null!;
}
