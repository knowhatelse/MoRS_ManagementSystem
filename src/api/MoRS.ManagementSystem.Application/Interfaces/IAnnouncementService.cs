using MoRS.ManagementSystem.Application.DTOs.Announcement;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IAnnouncementService :
    IGetService<AnnouncementResponse>,
    IAddService<AnnouncementResponse, CreateAnnouncementRequest>,
    IUpdateService<AnnouncementResponse, UpdateAnnouncemtRequest>
{

}
