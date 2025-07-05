using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Notification;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class NotificationProfile : Profile
{
    public NotificationProfile()
    {
        CreateMap<Notification, NotificationResponse>();
        CreateMap<UpdateNotificationRequest, Notification>();
    }
}
