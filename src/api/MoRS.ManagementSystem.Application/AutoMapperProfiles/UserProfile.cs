using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class UserProfile : Profile
{
    public UserProfile()
    {
        CreateMap<User, UserResponse>();
        CreateMap<CreateUserRequest, User>();
        CreateMap<UpdateUserRequest, User>();
    }
}
