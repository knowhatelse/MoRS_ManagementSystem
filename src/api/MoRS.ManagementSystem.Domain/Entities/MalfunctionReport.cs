using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class MalfunctionReport
{
    [Key]
    public int Id { get; set; }
    public required string Description { get; set; }
    public DateTime Date { get; set; }
    public bool IsArchived { get; set; }
}
