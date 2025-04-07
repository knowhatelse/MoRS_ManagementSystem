using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Role;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class RoleProfile : Profile
{
    public RoleProfile()
    {
        CreateMap<Role, RoleResponse>();
    }
}
