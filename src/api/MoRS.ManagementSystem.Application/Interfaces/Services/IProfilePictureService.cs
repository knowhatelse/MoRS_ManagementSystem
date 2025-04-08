using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IProfilePictureService :
    IUpdateService<ProfilePictureResponse, UpdateProfilePictureRequest>,
    IDeleteService
{

}
