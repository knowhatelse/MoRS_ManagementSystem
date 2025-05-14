using MoRS.ManagementSystem.Application.DTOs.Notification;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface INotificationService :
    IGetService<NotificationResponse, NotificationQuery>,
    IDeleteService
{

}
