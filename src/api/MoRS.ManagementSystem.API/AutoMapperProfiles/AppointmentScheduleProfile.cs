using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.AppointmentSchedule;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class AppointmentScheduleProfile : Profile
{
    public AppointmentScheduleProfile()
    {
        CreateMap<AppointmentSchedule, AppointmentScheduleResponse>();
        CreateMap<CreateAppointmentScheduleRequest, AppointmentSchedule>();
    }
}
