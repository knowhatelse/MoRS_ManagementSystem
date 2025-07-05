using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IRoomService : 
    IBaseService<RoomResponse, CreateRoomRequest, UpdateRoomRequest, RoomQuery>
{

}
