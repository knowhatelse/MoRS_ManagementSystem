using MoRS.ManagementSystem.Application.DTOs.Authentication;
using MoRS.ManagementSystem.Application.DTOs.User;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAuthenticationService
{
    Task<UserResponse> LoginAsync(LoginRequest request);
}
