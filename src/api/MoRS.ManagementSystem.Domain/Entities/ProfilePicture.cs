using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class ProfilePicture
{
    [Key]
    public int Id { get; set; }
    public required byte[] Data { get; set; }
    public required string FileName { get; set; }
    public required string FileType { get; set; }
}
