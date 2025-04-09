using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class RoomService(IMapper mapper, IRoomRepository repository) :
    BaseService<Room, RoomResponse, CreateRoomRequest, UpdateRoomRequest, RoomQuery>(mapper, repository),
    IRoomService
{

}
