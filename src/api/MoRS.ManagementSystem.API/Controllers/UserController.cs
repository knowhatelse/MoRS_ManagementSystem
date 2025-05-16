using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UserController(IUserService service)
    : BaseController<User, UserResponse, CreateUserRequest, UpdateUserRequest, UserQuery, IUserService>(service)
{
}
