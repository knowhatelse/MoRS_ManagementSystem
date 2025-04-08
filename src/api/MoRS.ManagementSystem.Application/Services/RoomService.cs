using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class RoomService(IMapper mapper, IRoomRepository repository) :
    BaseService<Room, RoomResponse, CreateRoomRequest, UpdateRoomRequest>(mapper, repository),
    IRoomService
{

}
