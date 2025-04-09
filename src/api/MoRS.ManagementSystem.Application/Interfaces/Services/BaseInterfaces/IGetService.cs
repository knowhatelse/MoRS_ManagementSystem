namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IGetService<TResponse, TQueryFilter>
{
    Task<IEnumerable<TResponse>> GetAsync(TQueryFilter? queryFilter);
    Task<TResponse?> GetByIdAsync(int id);
}
