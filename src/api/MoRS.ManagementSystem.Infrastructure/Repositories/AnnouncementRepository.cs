using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class AnnouncementRepository(MoRSManagementSystemDbContext context) : BaseRepository<Announcement, AnnouncementQuery>(context), IAnnouncementRepository
{
    protected override IQueryable<Announcement> ApplyQueryFilters(IQueryable<Announcement> query, AnnouncementQuery? queryFilter)
    {
        if (queryFilter?.IsDeleted is not null)
        {
            query = query.Where(a => a.IsDeleted == queryFilter.IsDeleted);
        }

        if (queryFilter?.IsUserIncluded == true)
        {
            query = query.Include(a => a.User);
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
