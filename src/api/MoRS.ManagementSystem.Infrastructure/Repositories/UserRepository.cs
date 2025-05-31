using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class UserRepository(MoRSManagementSystemDbContext context) : BaseRepository<User, UserQuery>(context), IUserRepository
{
    private readonly MoRSManagementSystemDbContext _context = context;

    public override async Task<User?> GetByIdAsync(int id)
    {
        return await _context.Users
            .Include(u => u.Role)
            .Include(u => u.ProfilePicture)
            .FirstOrDefaultAsync(u => u.Id == id);
    }

    protected override IQueryable<User> ApplyQueryFilters(IQueryable<User> query, UserQuery? queryFilter = null)
    {

        if (!string.IsNullOrWhiteSpace(queryFilter?.Name))
        {
            query = query.Where(u => u.Name == queryFilter.Name);
        }

        if (!string.IsNullOrWhiteSpace(queryFilter?.Surname))
        {
            query = query.Where(u => u.Surname == queryFilter.Surname);
        }

        if (!string.IsNullOrWhiteSpace(queryFilter?.Email))
        {
            query = query.Where(u => u.Email == queryFilter.Email);
        }

        if (!string.IsNullOrWhiteSpace(queryFilter?.PhoneNumber))
        {
            query = query.Where(u => u.PhoneNumber == queryFilter.PhoneNumber);
        }

        if (queryFilter?.IsRoleIncluded is true)
        {
            query = query.Include(u => u.Role);
        }

        if (queryFilter?.IsProfilePictureIncluded is true)
        {
            query = query.Include(u => u.ProfilePicture);
        }

        if (queryFilter?.Ids != null && queryFilter.Ids.Count != 0)
        {
            query = query.Where(u => queryFilter.Ids.Contains(u.Id));
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
