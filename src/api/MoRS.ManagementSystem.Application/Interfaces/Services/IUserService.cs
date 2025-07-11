using Microsoft.AspNetCore.Identity;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IUserService :
    IBaseService<UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>
{
    Task<bool> UpdatePasswordAsync(int userId, UpdatePasswordRequest request);
    Task<UserResponse?> UpdateUserAsync(int userId, UpdateUserRequest request);
    Task<bool> DeleteUserAsync(int userId);
}
