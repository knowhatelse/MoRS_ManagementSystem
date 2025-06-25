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
    private readonly IMapper _mapper = mapper;
    private readonly IUserRepository _repository = repository;
    private readonly INotificationRepository _notificationRepository = notificationRepository;

    protected override async Task BeforeInsertAsync(CreateUserRequest request, User entity)
    {
        var userRequest = _mapper.Map<User>(request);

        if (CheckUserEmails(userRequest, entity).Result)
        {
            throw new InvalidOperationException(Messages.EmailAlreadyExists);
        }

        if (CheckUserPhoneNumbers(userRequest, entity).Result)
        {
            throw new InvalidOperationException(Messages.PhoneNumberAlreadyExists);
        }

        CreateUserPassword(request, entity);

        await base.BeforeInsertAsync(request, entity);
    }

    protected override async Task BeforeUpdateAsync(UpdateUserRequest request, User? entity)
    {
        if (entity is null)
        {
            await base.BeforeUpdateAsync(request, entity);
            return;
        }

        var userRequest = _mapper.Map<User>(request);

        if (CheckUserEmails(userRequest, entity).Result)
        {
            throw new InvalidOperationException(Messages.EmailAlreadyExists);
        }

        if (CheckUserPhoneNumbers(userRequest, entity).Result)
        {
            throw new InvalidOperationException(Messages.PhoneNumberAlreadyExists);
        }

        if (entity.IsRestricted != request.IsRestricted)
        {
            var notification = new Notification
            {
                Title = Messages.UserRestricterd,
                Message = request.IsRestricted ? Messages.UserRestrictedTrue : Messages.UserRestrictedFalse,
                Type = request.IsRestricted ? NotificationType.Upozorenje : NotificationType.Informacija,
                Date = DateTime.Now,
                UserId = entity.Id
            };

            await _notificationRepository.AddAsync(notification);
        }

        await base.BeforeUpdateAsync(request, entity);
    }

    public async Task<bool> UpdatePasswordAsync(int userId, UpdatePasswordRequest request)
    {
        var user = await _repository.GetByIdAsync(userId);
        if (user == null)
        {
            return false;
        }

        PasswordHelper.CreatePasswordHash(request.NewPassword, out byte[] passwordHash, out byte[] passwordSalt);

        user.PasswordHash = passwordHash;
        user.PasswordSalt = passwordSalt;

        await _repository.UpdateAsync(user);
        return true;
    }

    private async Task<bool> CheckUserEmails(User request, User entity)
    {
        var existingEmails = await _repository.GetAsync(new UserQuery { Email = request.Email });
        existingEmails = [.. existingEmails.Where(x => x.Id != entity.Id)];

        foreach (var email in existingEmails)
        {
            if (email.Email == request.Email)
            {
                return true;
            }
        }

        return false;
    }

    private async Task<bool> CheckUserPhoneNumbers(User request, User entity)
    {
        var existingPhoneNumbers = await _repository.GetAsync(new UserQuery { PhoneNumber = request.PhoneNumber });
        existingPhoneNumbers = [.. existingPhoneNumbers.Where(x => x.Id != entity.Id)];

        foreach (var phoneNumber in existingPhoneNumbers)
        {
            if (phoneNumber.PhoneNumber == request.PhoneNumber)
            {
                return true;
            }
        }

        return false;
    }

    private static void CreateUserPassword(CreateUserRequest request, User entity)
    {
        var defaultPassword = $"{entity.Name.Trim().ToLower()}.{entity.Surname.Trim().ToLower()}";

        PasswordHelper.CreatePasswordHash(defaultPassword, out byte[] passwordHash, out byte[] passwordSalt);

        entity.PasswordHash = passwordHash;
        entity.PasswordSalt = passwordSalt;
    }
}
