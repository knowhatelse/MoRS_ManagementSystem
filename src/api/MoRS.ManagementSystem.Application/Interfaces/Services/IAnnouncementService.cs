using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAnnouncementService :
    IBaseService<AnnouncementResponse, CreateAnnouncementRequest, UpdateAnnouncementRequest, AnnouncementQuery>
{

}
