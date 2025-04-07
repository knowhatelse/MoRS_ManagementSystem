using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.Room;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class RoomProfile : Profile
{
    public RoomProfile()
    {
        CreateMap<Room, RoomResponse>();
        CreateMap<CreateRoomRequest, Room>();
    }
}
