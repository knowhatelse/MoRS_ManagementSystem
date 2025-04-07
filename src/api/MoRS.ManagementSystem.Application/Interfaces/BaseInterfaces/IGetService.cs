namespace MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

public interface IGetService<TResponse>
{
    Task<IEnumerable<TResponse>> GetAsync();
    Task<TResponse?> GetByIdAsync(int id);
}
