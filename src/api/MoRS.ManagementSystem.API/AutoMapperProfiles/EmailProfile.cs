using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.Email;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class EmailProfile : Profile
{
    public EmailProfile()
    {
        CreateMap<CreateEmailRequest, Email>();
    }
}
