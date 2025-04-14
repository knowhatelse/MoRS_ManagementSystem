using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;


namespace MoRS.ManagementSystem.Application.Services;

public class UserService(IMapper mapper, IUserRepository repository) :
    BaseService<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>(mapper, repository),
    IUserService
{
    private readonly IMapper _mapper = mapper;
    private readonly IUserRepository _repository = repository;

    public async override Task<UserResponse> AddAsync(CreateUserRequest request)
    {
        var result = await base.AddAsync(request) ?? throw new InvalidOperationException(ErrorMessages.EmailConflict);
        return result;
    }
}
