using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class RoomRepository(MoRSManagementSystemDbContext context) : BaseRepository<Room, RoomQuery>(context), IRoomRepository
{
    public override IQueryable<Room> ApplyQueryFilters(IQueryable<Room> query, RoomQuery? queryFilter = null)
    {
        if (queryFilter?.IsActive is not null)
        {
            query = query.Where(r => r.IsActive == queryFilter.IsActive);
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
