using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Notification;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class NotificationService(IMapper mapper, INotificationRepository repository) :
    BaseService<Notification, NotificationResponse, EmptyDto, UpdateNotificationRequest, NotificationQuery>(mapper, repository),
    INotificationService
{

}
