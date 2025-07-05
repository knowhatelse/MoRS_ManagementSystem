using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.TimeSlot;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class TimeSlotProfile : Profile
{
    public TimeSlotProfile()
    {
        CreateMap<TimeSlot, TimeSlotResponse>();
        CreateMap<CreateTimeSlotRequest, TimeSlot>();
    }
}
