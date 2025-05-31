using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class ProfilePictureProfile : Profile
{
    public ProfilePictureProfile()
    {
        CreateMap<ProfilePicture, ProfilePictureResponse>()
            .ForMember(dest => dest.Base64Data, opt => opt.MapFrom(src => Convert.ToBase64String(src.Data)));
        CreateMap<CreateProfilePictureRequest, ProfilePicture>()
             .ForMember(dest => dest.Data, opt => opt.MapFrom(src => Convert.FromBase64String(src.Base64Data)));
    }
}
