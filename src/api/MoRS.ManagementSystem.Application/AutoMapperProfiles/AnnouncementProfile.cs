using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class AnnouncementProfile : Profile
{
    public AnnouncementProfile()
    {
        CreateMap<Announcement, AnnouncementResponse>();
        CreateMap<CreateAnnouncementRequest, Announcement>();
        CreateMap<UpdateAnnouncemtRequest, Announcement>();
    }
}
