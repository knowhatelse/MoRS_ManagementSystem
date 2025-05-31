namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IBaseService<TResponse, TCreateRequest, TUpdateRequest, TQueryFilter>
{
    Task<IEnumerable<TResponse>> GetAsync(TQueryFilter? queryFilter);
    Task<TResponse?> GetByIdAsync(int id);
    Task<TResponse> AddAsync(TCreateRequest request);
    Task<TResponse?> UpdateAsync(int id, TUpdateRequest request);
    Task<bool> DeleteAsync(int id);
}
