using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class ProfilePictureProfile : Profile
{
    public ProfilePictureProfile()
    {
        CreateMap<ProfilePicture, ProfilePictureResponse>();
        CreateMap<AddProfilePictureRequest, ProfilePicture>();
    }
}
