using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class ProfilePictureService(IMapper mapper, IProfilePictureRepository repository) :
    BaseService<ProfilePicture, ProfilePictureResponse, CreateProfilePictureRequest, EmptyDto, EmptyQuery>(mapper, repository),
    IProfilePictureService
{
    protected override async Task BeforeInsertAsync(CreateProfilePictureRequest request, ProfilePicture entity)
    {
        if (string.IsNullOrWhiteSpace(request.Base64Data))
        {
            throw new ArgumentException("Base64 data cannot be null or empty.");
        }

        entity.FileName = $"{request.UserId}_profile_picture.png";
        entity.FileType = "image/png";
        entity.UserId = request.UserId;

        await base.BeforeInsertAsync(request, entity);
    }
}
