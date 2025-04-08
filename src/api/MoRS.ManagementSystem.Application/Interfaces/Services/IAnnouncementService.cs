using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAnnouncementService :
    IGetService<AnnouncementResponse>,
    IAddService<AnnouncementResponse, CreateAnnouncementRequest>,
    IUpdateService<AnnouncementResponse, UpdateAnnouncementRequest>
{

}
