
using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Interfaces.Repositories.BaseInterfaces;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class BaseRepository<TEntity, TQueryFilter>(MoRSManagementSystemDbContext context) :
    IBaseRepository<TEntity, TQueryFilter>
    where TEntity : class
    where TQueryFilter : class
{
    private readonly MoRSManagementSystemDbContext _context = context;

    public virtual async Task<TEntity?> AddAsync(TEntity entity)
    {
        await _context.Set<TEntity>().AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public virtual async Task<bool> DeleteAsync(TEntity entity)
    {
        _context.Set<TEntity>().Remove(entity);
        var result = await _context.SaveChangesAsync();
        return result > 0;
    }

    public virtual async Task<IEnumerable<TEntity>> GetAsync(TQueryFilter? queryFilter = null)
    {
        var query = _context.Set<TEntity>().AsQueryable();
        query = ApplyQueryFilters(query, queryFilter);
        return await query.ToListAsync();
    }

    public virtual async Task<TEntity?> GetByIdAsync(int id)
    {
        return await _context.Set<TEntity>().FindAsync(id);
    }

    public virtual async Task<TEntity?> UpdateAsync(TEntity entity)
    {
        _context.Set<TEntity>().Update(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    protected virtual IQueryable<TEntity> ApplyQueryFilters(IQueryable<TEntity> query, TQueryFilter? queryFilter)
    {
        return query;
    }
}
