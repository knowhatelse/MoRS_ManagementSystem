using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IUserService :
    IGetService<UserResponse>,
    IAddService<UserResponse, CreateUserRequest>,
    IUpdateService<UserResponse, UpdateUserRequest>,
    IDeleteService
{

}
