namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAuthenticationService<TResponse, TRequest>
{
    Task<TResponse> LoginAsync(TRequest request);
}
