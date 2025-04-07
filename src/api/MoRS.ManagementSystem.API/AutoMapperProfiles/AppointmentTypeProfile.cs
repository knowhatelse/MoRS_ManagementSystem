using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.AppointmentType;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class AppointmentTypeProfile : Profile
{
    public AppointmentTypeProfile()
    {
        CreateMap<AppointmentType, AppointmentTypeResponse>();
    }
}
