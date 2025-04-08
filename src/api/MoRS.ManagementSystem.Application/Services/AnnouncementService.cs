using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class AnnouncementService(IMapper mapper, IAnnouncementRepository repository) :
    BaseService<Announcement, AnnouncementResponse, CreateAnnouncementRequest, UpdateAnnouncementRequest>(mapper, repository),
    IAnnouncementService
{

}
