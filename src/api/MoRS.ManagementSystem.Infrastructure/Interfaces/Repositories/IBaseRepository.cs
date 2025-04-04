namespace MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;

public interface IBaseRepository<TEntity>
{
    Task<IEnumerable<TEntity>> GetAsync();
    Task<TEntity?> GetByIdAsync(int id);
    Task<TEntity> AddAsync(TEntity entity);
    Task<TEntity> UpdateAsync(TEntity entity);
    Task<bool> DeleteAsync(TEntity entity);
}
