using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class User
{
    [Key]
    public int Id { get; set; }
    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Email { get; set; }
    public required string PhoneNumber { get; set; }
    public required string PasswordHash { get; set; }
    public required string PasswordSalt { get; set; }
    public bool IsRestricted { get; set; }
}
