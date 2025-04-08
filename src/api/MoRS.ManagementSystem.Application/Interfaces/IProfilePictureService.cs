using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IProfilePictureService :
    IUpdateService<ProfilePictureResponse, UpdateProfilePictureRequest>,
    IDeleteService
{

}
