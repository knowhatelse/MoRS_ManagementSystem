using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class AnnouncementService(IMapper mapper, IAnnouncementRepository repository) :
    BaseService<Announcement, AnnouncementResponse, CreateAnnouncementRequest, UpdateAnnouncemtRequest>(mapper, repository),
    IAnnouncementService
{

}
