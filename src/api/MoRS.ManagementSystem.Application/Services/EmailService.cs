using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Events;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class EmailService(IMapper mapper, IEmailRepository emailRepository, IUserRepository userRepository, IEventBus eventBus) :
    BaseService<Email, EmailResponse, CreateEmailRequest, EmptyDto, EmptyQuery>(mapper, emailRepository),
    IEmailService
{
    private readonly IUserRepository _userRepository = userRepository;
    private readonly IEventBus _eventBus = eventBus;

    protected override async Task BeforeInsertAsync(CreateEmailRequest request, Email entity)
    {
        var users = await _userRepository.GetAsync(new UserQuery { Ids = request.UserIds });
        entity.Users = [.. users];

        await base.BeforeInsertAsync(request, entity);
    }

    protected override async Task AfterInsertAsync(CreateEmailRequest request, Email entity)
    {
        List<string> userEmails = [];

        foreach (var userId in request.UserIds)
        {
            var user = await _userRepository.GetByIdAsync(userId);
            userEmails.Add(user!.Email);
        }

        var evt = new EmailCreatedEvent
        {
            Subject = request.Subject,
            Body = request.Body,
            UserEmails = userEmails
        };

        await _eventBus.PublishAsync("email-created", evt);

        await base.AfterInsertAsync(request, entity);
    }
}
