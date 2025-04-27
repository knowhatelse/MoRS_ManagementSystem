using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;

public class CreateMalfunctionReportRequest
{
    [Required]
    [StringLength(1000, MinimumLength = 10)]
    public required string Description { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int RoomId { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int ReportedByUserId { get; set; }
}

