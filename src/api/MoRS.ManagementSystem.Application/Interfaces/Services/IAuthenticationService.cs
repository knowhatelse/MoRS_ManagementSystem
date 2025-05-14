namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAuthenticationService<TResponse, TRequest>
{
    public Task<TResponse> LoginAsync(TRequest request);
}
