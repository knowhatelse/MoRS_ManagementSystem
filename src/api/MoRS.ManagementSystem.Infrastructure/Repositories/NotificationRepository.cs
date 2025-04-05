using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;
using MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class NotificationRepository(MoRSManagementSystemDbContext context) : BaseRepository<Notification>(context), INotificationRepository
{

}
