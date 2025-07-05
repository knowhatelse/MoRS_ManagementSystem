using AutoMapper;
using Microsoft.Extensions.Logging;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Email;
using MoRS.ManagementSystem.Application.Events;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class EmailService(IMapper mapper, IEmailRepository emailRepository, IUserRepository userRepository, IEventBus eventBus, ILogger<EmailService> logger) :
    BaseService<Email, EmailResponse, CreateEmailRequest, EmptyDto, EmptyQuery>(mapper, emailRepository),
    IEmailService
{
    private readonly IUserRepository _userRepository = userRepository;
    private readonly IEventBus _eventBus = eventBus;
    private readonly ILogger<EmailService> _logger = logger;

    public override async Task<EmailResponse> AddAsync(CreateEmailRequest request)
    {
        _logger.LogInformation("DEBUG: EmailService.AddAsync called with request: {@Request}", request);

        try
        {
            _logger.LogInformation("DEBUG: Starting email creation process...");
            var result = await base.AddAsync(request);
            _logger.LogInformation("DEBUG: Email creation successful: {@Result}", result);
            return result;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "ERROR: Failed to create email: {Message}", ex.Message);
            _logger.LogError("ERROR: Stack trace: {StackTrace}", ex.StackTrace);
            throw;
        }
    }

    protected override async Task BeforeInsertAsync(CreateEmailRequest request, Email entity)
    {
        _logger.LogInformation("DEBUG: BeforeInsertAsync called with UserIds: {@UserIds}", request.UserIds);

        try
        {
            _logger.LogInformation("DEBUG: Getting users from repository...");
            var users = await _userRepository.GetAsync(new UserQuery { Ids = request.UserIds });
            _logger.LogInformation("DEBUG: Found {Count} users: {@Users}", users.Count(), users.Select(u => new { u.Id, u.Email, u.Name }));

            entity.Users = [.. users];
            _logger.LogInformation("DEBUG: Users assigned to email entity");

            await base.BeforeInsertAsync(request, entity);
            _logger.LogInformation("DEBUG: BeforeInsertAsync completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "ERROR: BeforeInsertAsync failed: {Message}", ex.Message);
            throw;
        }
    }

    protected override async Task AfterInsertAsync(CreateEmailRequest request, Email entity)
    {
        _logger.LogInformation("DEBUG: AfterInsertAsync called for email ID: {EmailId}", entity.Id);

        try
        {
            List<string> userEmails = [];

            _logger.LogInformation("DEBUG: Getting user emails for UserIds: {@UserIds}", request.UserIds);
            foreach (var userId in request.UserIds)
            {
                _logger.LogInformation("DEBUG: Getting user with ID: {UserId}", userId);
                var user = await _userRepository.GetByIdAsync(userId);
                if (user != null)
                {
                    userEmails.Add(user.Email);
                    _logger.LogInformation("DEBUG: Added email: {Email} for user: {Name}", user.Email, user.Name);
                }
                else
                {
                    _logger.LogWarning("WARNING: User with ID {UserId} not found", userId);
                }
            }

            var evt = new EmailCreatedEvent
            {
                Subject = request.Subject,
                Body = request.Body,
                UserEmails = userEmails
            };

            _logger.LogInformation("DEBUG: Publishing email-created event: {@Event}", evt);
            await _eventBus.PublishAsync("email-created", evt);
            _logger.LogInformation("DEBUG: Event published successfully");

            await base.AfterInsertAsync(request, entity);
            _logger.LogInformation("DEBUG: AfterInsertAsync completed successfully");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "ERROR: AfterInsertAsync failed: {Message}", ex.Message);
            throw;
        }
    }
}
