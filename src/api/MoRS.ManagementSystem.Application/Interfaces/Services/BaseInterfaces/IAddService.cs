namespace MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

public interface IAddService<TResponse, TCreateRequest>
{
    Task<TResponse> AddAsync(TCreateRequest request);
}
