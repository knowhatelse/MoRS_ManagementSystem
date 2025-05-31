using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class EmailService(IMapper mapper, IEmailRepository emailRepository, IUserRepository userRepository) :
    BaseService<Email, EmailResponse, CreateEmailRequest, EmptyDto, EmptyQuery>(mapper, emailRepository),
    IEmailService
{
    private readonly IUserRepository _userRepository = userRepository;

    protected override async Task BeforeInsertAsync(CreateEmailRequest request, Email entity)
    {
        var users = await _userRepository.GetAsync(new UserQuery { Ids = request.UserIds });
        entity.Users = [.. users];
        
        await base.BeforeInsertAsync(request, entity);
    }
}
