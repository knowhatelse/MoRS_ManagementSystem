using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;


namespace MoRS.ManagementSystem.Application.Services;

public class UserService(IMapper mapper, IUserRepository repository) :
    BaseService<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>(mapper, repository),
    IUserService
{

}
