using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class UserRepository(MoRSManagementSystemDbContext context) : BaseRepository<User, UserQuery>(context), IUserRepository
{
    public override IQueryable<User> ApplyQueryFilters(IQueryable<User> query, UserQuery? queryFilter = null)
    {

        if (!string.IsNullOrWhiteSpace(queryFilter?.Name))
        {
            query = query.Where(u => u.Name == queryFilter.Name);
        }

        if (!string.IsNullOrWhiteSpace(queryFilter?.Surname))
        {
            query = query.Where(u => u.Surname == queryFilter.Surname);
        }

        if (queryFilter?.IsRoleIncluded is true)
        {
            query = query.Include(u => u.Role);
        }

        if (queryFilter?.IsProfilePictureIncluded is true)
        {
            query = query.Include(u => u.ProfilePicture);
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
