using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Role
{
    [Key]
    public int Id { get; set; }
    public required string Name { get; set; }
}
