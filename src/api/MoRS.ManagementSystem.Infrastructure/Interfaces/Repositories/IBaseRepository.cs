namespace MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;

public interface IBaseRepository<TEntitiy>
{
    Task<IEnumerable<TEntitiy>> GetAsync();
    Task<TEntitiy?> GetByIdAsync(int id);
    Task<TEntitiy> AddAsync(TEntitiy entity);
    Task<TEntitiy> UpdateAsync(TEntitiy entity);
    Task<bool> DeleteAsync(TEntitiy entitiy);
}
