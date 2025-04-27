namespace MoRS.ManagementSystem.Application.Interfaces.Repositories.BaseInterfaces;

public interface IBaseRepository<TEntity, TQueryFilter>
{
    Task<IEnumerable<TEntity>> GetAsync(TQueryFilter? queryFilter);
    Task<TEntity?> GetByIdAsync(int id);
    Task<TEntity?> AddAsync(TEntity entity);
    Task<TEntity?> UpdateAsync(TEntity entity);
    Task<bool> DeleteAsync(TEntity entity);
}
