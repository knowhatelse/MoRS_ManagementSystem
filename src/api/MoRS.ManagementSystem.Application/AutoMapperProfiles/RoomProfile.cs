using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class RoomProfile : Profile
{
    public RoomProfile()
    {
        CreateMap<Room, RoomResponse>();
        CreateMap<CreateRoomRequest, Room>();
    }
}
