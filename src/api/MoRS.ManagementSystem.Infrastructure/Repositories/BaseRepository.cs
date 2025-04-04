
using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Infrastructure.Data;
using MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class BaseRepository<TEntity>(MoRSManagementSystemDbContext context) : IBaseRepository<TEntity> where TEntity : class
{
    private readonly MoRSManagementSystemDbContext _context = context;

    public async Task<TEntity> AddAsync(TEntity entity)
    {
        await _context.Set<TEntity>().AddAsync(entity);
        await _context.SaveChangesAsync();
        return entity;
    }

    public async Task<bool> DeleteAsync(TEntity entity)
    {
        _context.Set<TEntity>().Remove(entity);
        var result = await _context.SaveChangesAsync();
        return result > 0;
    }

    public async Task<IEnumerable<TEntity>> GetAsync()
    {
        return await _context.Set<TEntity>().ToListAsync();
    }

    public async Task<TEntity?> GetByIdAsync(int id)
    {
        return await _context.Set<TEntity>().FindAsync(id);
    }

    public async Task<TEntity> UpdateAsync(TEntity entity)
    {
        _context.Set<TEntity>().Update(entity);
        await _context.SaveChangesAsync();
        return entity;
    }
}
