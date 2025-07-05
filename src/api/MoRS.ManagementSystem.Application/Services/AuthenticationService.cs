using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Authentication;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;

namespace MoRS.ManagementSystem.Application.Services;

public class AuthenticationService(IMapper mapper, IUserRepository repository) : IAuthenticationService
{
    private readonly IMapper _mapper = mapper;
    private readonly IUserRepository _repository = repository; public async Task<UserResponse> LoginAsync(LoginRequest request)
    {
        var userQuery = new UserQuery
        {
            Email = request.Email
        };

        var user = await _repository.GetAsync(userQuery);

        if (user is null || !user.Any())
        {
            throw new UnauthorizedAccessException(Messages.InvalidCredentials);
        }
       
        return _mapper.Map<UserResponse>(user.First());
    }
}
