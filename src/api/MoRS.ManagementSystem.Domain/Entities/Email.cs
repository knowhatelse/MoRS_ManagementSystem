using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Email
{
    [Key]
    public int Id { get; set; }
    public required string Subject { get; set; }
    public required string Body { get; set; }
}
