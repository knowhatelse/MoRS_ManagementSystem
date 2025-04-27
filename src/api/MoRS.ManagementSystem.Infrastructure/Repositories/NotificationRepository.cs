using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class NotificationRepository(MoRSManagementSystemDbContext context) : BaseRepository<Notification, NotificationQuery>(context), INotificationRepository
{
    protected override IQueryable<Notification> ApplyQueryFilters(IQueryable<Notification> query, NotificationQuery? queryFilter)
    {
        if(queryFilter?.IsRead is not null) 
        {
            query = query.Where(n => n.IsRead == queryFilter.IsRead);
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
