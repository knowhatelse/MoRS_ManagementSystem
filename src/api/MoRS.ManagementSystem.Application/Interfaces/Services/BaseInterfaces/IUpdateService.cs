namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IUpdateService<TResponse, TUpdateRequest>
{
    Task<TResponse?> UpdateAsync(int id, TUpdateRequest request);
}
