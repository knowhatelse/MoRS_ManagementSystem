namespace MoRS.ManagementSystem.Application.DTOs.ProfilePicture;

public class ProfilePictureResponse
{
    public int Id { get; set; }
    public required string Base64Data { get; set; }
    public required string FileName { get; set; }
    public required string FileType { get; set; }
}
