using Microsoft.AspNetCore.Mvc;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public abstract class BaseController<TEntity, TResponse, TCreateRequest, TUpdateRequest, TQuery>(IBaseService<TResponse, TCreateRequest, TUpdateRequest, TQuery> service) :
    ControllerBase
    where TQuery : class
{
    protected readonly IBaseService<TResponse, TCreateRequest, TUpdateRequest, TQuery> _service = service;

    [HttpGet]
    public virtual async Task<ActionResult<IEnumerable<TResponse>>> Get([FromQuery] TQuery? queryFilter = null)
    {
        var result = await _service.GetAsync(queryFilter);
        return Ok(result);
    }

    [HttpGet("{id}")]
    public virtual async Task<ActionResult<TResponse>> GetById(int id)
    {
        var result = await _service.GetByIdAsync(id);
        return result == null ? NotFound() : Ok(result);
    }


    [HttpPost]
    public virtual async Task<ActionResult<TResponse>> Add([FromBody] TCreateRequest request)
    {
        var result = await _service.AddAsync(request);

        if (result is null)
        {
            BadRequest();
        }

        return Ok(result);
    }


    [HttpPut("{id}")]
    public virtual async Task<ActionResult<TResponse>> Update(int id, [FromBody] TUpdateRequest request)
    {
        var result = await _service.UpdateAsync(id, request);
        return result == null ? NotFound() : Ok(result);
    }


    [HttpDelete("{id}")]
    public virtual async Task<IActionResult> Delete(int id)
    {
        var success = await _service.DeleteAsync(id);
        return success ? NoContent() : NotFound();
    }

    protected virtual int GetEntityId(TResponse entity)
    {
        return (int)entity!.GetType().GetProperty("Id")?.GetValue(entity)!;
    }
}
