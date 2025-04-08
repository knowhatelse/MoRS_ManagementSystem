using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IUserService :
    IGetService<UserResponse>,
    IAddService<UserResponse, CreateUserRequest>,
    IUpdateService<UserResponse, UpdateUserRequest>,
    IDeleteService
{

}
