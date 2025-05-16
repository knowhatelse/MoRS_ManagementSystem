using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.Room;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RoomController(IRoomService service)
    : BaseController<Room, RoomResponse, CreateRoomRequest, UpdateRoomRequest, RoomQuery, IRoomService>(service)
{
}
