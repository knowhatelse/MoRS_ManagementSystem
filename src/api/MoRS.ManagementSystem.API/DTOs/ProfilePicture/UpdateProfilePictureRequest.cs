namespace MoRS.ManagementSystem.API.DTOs.ProfilePicture;

public class UpdateProfilePictureRequest
{
    public int UserId { get; set; }
    public required string Base64Data { get; set; }
    public required string FileName { get; set; }
    public required string FileType { get; set; }
}
