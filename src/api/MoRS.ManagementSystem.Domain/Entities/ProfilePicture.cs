namespace MoRS.ManagementSystem.Domain.Entities;

public class ProfilePicture
{
    public int Id { get; set; }
    public required byte[] Data { get; set; }
    public required string FileName { get; set; }
    public required string FileType { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;
}
