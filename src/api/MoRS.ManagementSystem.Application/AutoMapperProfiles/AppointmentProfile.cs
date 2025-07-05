using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class AppointmentProfile : Profile
{
    public AppointmentProfile()
    {
        CreateMap<Appointment, AppointmentResponse>();
        CreateMap<CreateAppointmentRequest, Appointment>()
            .ForMember(dest => dest.DayOfOccurrance, opt => opt.Ignore());
        CreateMap<UpdateAppointmentRequest, Appointment>();
    }
}
