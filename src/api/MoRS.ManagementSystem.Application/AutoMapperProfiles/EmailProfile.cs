using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class EmailProfile : Profile
{
    public EmailProfile()
    {
        CreateMap<Email, EmailResponse>();
        CreateMap<CreateEmailRequest, Email>();
    }
}
