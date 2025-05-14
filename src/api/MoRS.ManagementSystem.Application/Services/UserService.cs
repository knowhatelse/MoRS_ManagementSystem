using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;


namespace MoRS.ManagementSystem.Application.Services;

public class UserService(IMapper mapper, IUserRepository repository, INotificationRepository notificationRepository) :
    BaseService<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>(mapper, repository),
    IUserService
{
    private readonly IUserRepository _repository = repository;
    private readonly INotificationRepository _notificationRepository = notificationRepository;

    protected override async Task BeforeInsertAsync(CreateUserRequest request, User entity)
    {
        var emailExists = await _repository.GetAsync(new UserQuery { Email = entity.Email });

        if (emailExists != null)
        {
            throw new InvalidOperationException(Messages.EmailAlreadyExists);
        }

        var defaultPassword = $"{entity.Name.Trim().ToLower()}.{entity.Surname.Trim().ToLower()}";

        PasswordHelper.CreatePasswordHash(defaultPassword, out byte[] passwordHash, out byte[] passwordSalt);

        entity.PasswordHash = passwordHash;
        entity.PasswordSalt = passwordSalt;
    }

    protected override async Task<Task> AfterUpdateAsync(UpdateUserRequest request, User? entity)
    {
        if (entity is null)
        {
            return base.AfterUpdateAsync(request, entity);
        }

        if (entity.IsRestricted && request.IsRestricted)
        {
            var userRestrictedNotification = new Notification
            {
                Title = Messages.UserRestricterd,
                Message = Messages.UserRestrictedTrue,
                Type = NotificationType.Upozorenje,
                Date = DateTime.Now,
                UserId = entity.Id
            };

            await _notificationRepository.AddAsync(userRestrictedNotification);
        }

        if (!entity.IsRestricted && !request.IsRestricted)
        {
            var userUnrestrictedNotification = new Notification
            {
                Title = Messages.UserRestricterd,
                Message = Messages.UserRestrictedFalse,
                Type = NotificationType.Informacija,
                Date = DateTime.Now,
                UserId = entity.Id
            };

            await _notificationRepository.AddAsync(userUnrestrictedNotification);
        }

        return base.AfterUpdateAsync(request, entity);
    }
}
