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
    BaseService<ProfilePicture, ProfilePictureResponse, CreateProfilePictureRequest, EmptyDto, NoQuery>(mapper, repository),
    IProfilePictureService
{
    protected override Task BeforeInsertAsync(CreateProfilePictureRequest request, ProfilePicture entity)
    {
        entity.Data = Convert.FromBase64String(request.Base64Data);

        string detectedFileType = FileHelper.DetectFileType(entity.Data);
        entity.FileType = detectedFileType;

        entity.FileName = $"user_{request.UserId}_{DateTime.Now.Ticks}.{FileHelper.GetExtensionFromType(detectedFileType)}";

        return Task.CompletedTask;
    }
}
