using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class ProfilePictureService(IMapper mapper, IProfilePictureRepository repository) :
    BaseService<ProfilePicture, ProfilePictureResponse, EmptyDto, UpdateProfilePictureRequest>(mapper, repository),
    IProfilePictureService
{

}
