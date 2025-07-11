using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Application.DTOs.ProfilePicture;

public class CreateProfilePictureRequest
{
    [Required]
    [Range(1, int.MaxValue)]
    public int UserId { get; set; }

    [Required]
    [StringLength(2000000, MinimumLength = 10)]
    public required string Base64Data { get; set; }
   
}
