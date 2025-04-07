using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.AppointmentSchedule;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class AppointmentScheduleProfile : Profile
{
    public AppointmentScheduleProfile()
    {
        CreateMap<AppointmentSchedule, AppointmentScheduleResponse>();
        CreateMap<CreateAppointmentScheduleRequest, AppointmentSchedule>();
    }
}
