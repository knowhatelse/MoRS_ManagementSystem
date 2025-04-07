using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class ProfilePictureProfile : Profile
{
    public ProfilePictureProfile()
    {
        CreateMap<ProfilePicture, ProfilePictureResponse>();
        CreateMap<UpdateProfilePictureRequest, ProfilePictureResponse>();
    }
}
