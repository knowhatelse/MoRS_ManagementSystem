using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class ProfilePictureService(IMapper mapper, IProfilePictureRepository repository) :
    BaseService<ProfilePicture,ProfilePictureResponse, EmptyDto, UpdateProfilePictureRequest>(mapper, repository),
    IProfilePictureService
{

}
