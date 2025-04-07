namespace MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

public interface IUpdateService<TResponse, TUpdateRequest>
{
    Task<TResponse?> UpdateAsync(int id, TUpdateRequest request);
}
