namespace MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

public interface IAddService<TResponse, TCreateRequest>
{
    Task<TResponse> AddAsync(TCreateRequest request);
}
