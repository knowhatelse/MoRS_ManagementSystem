namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IGetService<TResponse>
{
    Task<IEnumerable<TResponse>> GetAsync();
    Task<TResponse?> GetByIdAsync(int id);
}
