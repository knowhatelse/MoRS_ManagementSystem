using AutoMapper;
using Microsoft.AspNetCore.Identity;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;


namespace MoRS.ManagementSystem.Application.Services;

public class UserService : BaseService<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery>, IUserService
{
    private readonly IMapper _mapper;
    private readonly IUserRepository _repository;
    private readonly INotificationRepository _notificationRepository;

    public UserService(
        IMapper mapper,
        IUserRepository repository,
        INotificationRepository notificationRepository)
        : base(mapper, repository)
    {
        _mapper = mapper;
        _repository = repository;
        _notificationRepository = notificationRepository;
    }

    protected override async Task BeforeInsertAsync(CreateUserRequest request, User entity)
    {
        await base.BeforeInsertAsync(request, entity);
    }

    protected override async Task BeforeUpdateAsync(UpdateUserRequest request, User? entity)
    {
        if (entity is null)
        {
            await base.BeforeUpdateAsync(request, entity);
            return;
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

    public Task<bool> UpdatePasswordAsync(int userId, UpdatePasswordRequest request)
    {
        return Task.FromResult(false);
    }

    public Task<UserResponse?> UpdateUserAsync(int userId, UpdateUserRequest request)
    {
        throw new NotImplementedException("UpdateUserAsync is implemented in the Infrastructure layer.");
    }

    public Task<bool> DeleteUserAsync(int userId)
    {
        throw new NotImplementedException("DeleteUserAsync is implemented in the Infrastructure layer.");
    }
}
