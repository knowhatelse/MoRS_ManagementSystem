using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IRoomService :
    IGetService<RoomResponse, RoomQuery>,
    IAddService<RoomResponse, CreateRoomRequest>,
    IUpdateService<RoomResponse, UpdateRoomRequest>,
    IDeleteService
{

}
