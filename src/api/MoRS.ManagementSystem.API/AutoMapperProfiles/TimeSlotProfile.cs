using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.TimeSlot;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class TimeSlotProfile : Profile
{
    public TimeSlotProfile()
    {
        CreateMap<TimeSlot, TimeSlotResponse>();
        CreateMap<CreateTimeSlotRequest, TimeSlot>();
    }
}
