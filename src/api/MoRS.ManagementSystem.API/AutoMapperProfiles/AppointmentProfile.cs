using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.Appointment;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class AppointmentProfile : Profile
{
    public AppointmentProfile()
    {
        CreateMap<Appointment, AppointmentResponse>();
        CreateMap<CreateAppointmentRequest, Appointment>();
        CreateMap<UpdateAppointmentRequest, Appointment>();
    }
}
