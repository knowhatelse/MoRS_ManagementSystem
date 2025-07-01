using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.ProfilePicture;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProfilePictureController(IProfilePictureService service)
    : BaseController<ProfilePicture, ProfilePictureResponse, CreateProfilePictureRequest, EmptyDto, EmptyQuery>(service)
{
    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<IEnumerable<ProfilePictureResponse>>> Get(EmptyQuery? queryFilter = null) => base.Get(queryFilter);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<ProfilePictureResponse>> GetById(int id) => base.GetById(id);

    [ApiExplorerSettings(IgnoreApi = true)]
    [NonAction]
    public override Task<ActionResult<ProfilePictureResponse>> Update(int id, EmptyDto request) => base.Update(id, request);
}
