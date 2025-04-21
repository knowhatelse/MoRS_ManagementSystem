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
    private readonly IUserRepository _repository = repository;

    protected override async Task BeforeInsertAsync(CreateUserRequest request, User entity)
    {
        var emailExists = await _repository.GetAsync(new UserQuery { Email = entity.Email });

        if (emailExists != null)
        {
            throw new InvalidOperationException(ErrorMessages.EmailAlreadyExists);
        }

        var defaultPassword = $"{entity.Name.Trim().ToLower()}.{entity.Surname.Trim().ToLower()}";

        PasswordHelper.CreatePasswordHash(defaultPassword, out byte[] passwordHash,out byte[] passwordSalt);

        entity.PasswordHash = passwordHash;
        entity.PasswordSalt = passwordSalt;
    }
}
