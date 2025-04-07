using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.Role;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class RoleProfile : Profile
{
    public RoleProfile()
    {
        CreateMap<Role, RoleResponse>();
    }
}
