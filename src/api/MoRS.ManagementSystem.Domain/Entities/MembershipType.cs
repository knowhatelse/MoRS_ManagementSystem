using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class MembershipType
{
    [Key]
    public int Id { get; set; }
    public required string Type { get; set; }
}
