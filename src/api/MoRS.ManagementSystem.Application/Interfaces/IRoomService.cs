using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IRoomService :
    IGetService<RoomResponse>,
    IAddService<RoomResponse, CreateRoomRequest>,
    IUpdateService<RoomResponse, UpdateRoomRequest>,
    IDeleteService
{

}
