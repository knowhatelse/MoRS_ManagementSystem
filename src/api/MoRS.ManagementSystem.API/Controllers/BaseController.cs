using Microsoft.AspNetCore.Mvc;

namespace MoRS.ManagementSystem.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public abstract class BaseController<TEntity, TResponse, TCreateRequest, TUpdateRequest, TQuery, TService>(TService service) : ControllerBase
    where TEntity : class
    where TCreateRequest : class
    where TUpdateRequest : class
    where TQuery : class
    where TService : class
{
    protected readonly TService _service = service;

    [HttpGet]
    public virtual async Task<ActionResult<IEnumerable<TResponse>>> Get([FromQuery] TQuery? queryFilter = null)
    {
        var result = await CallService<IEnumerable<TResponse>>("GetAsync", queryFilter!);
        return Ok(result);
    }

    [HttpGet("{id}")]
    public virtual async Task<ActionResult<TResponse>> GetById(int id)
    {
        var result = await CallService<TResponse>("GetByIdAsync", id);
        return result == null ? NotFound() : Ok(result);
    }


    [HttpPost]
    public virtual async Task<ActionResult<TResponse>> Add([FromBody] TCreateRequest request)
    {
        var result = await CallService<TResponse>("AddAsync", request);
        var id = GetEntityId(result);
        return CreatedAtAction(nameof(GetById), new { id }, result);
    }


    [HttpPut("{id}")]
    public virtual async Task<ActionResult<TResponse>> Update(int id, [FromBody] TUpdateRequest request)
    {
        var result = await CallService<TResponse>("UpdateAsync", id, request);
        return result == null ? NotFound() : Ok(result);
    }


    [HttpDelete("{id}")]
    public virtual async Task<IActionResult> Delete(int id)
    {
        var success = await CallService<bool>("DeleteAsync", id);
        return success ? NoContent() : NotFound();
    }

    protected virtual int GetEntityId(TResponse entity)
    {
        return (int)entity!.GetType().GetProperty("Id")?.GetValue(entity)!;
    }

    private async Task<T> CallService<T>(string methodName, params object[]? parameters)
    {
        var method = typeof(TService).GetMethod(methodName)
            ?? throw new NotImplementedException($"{methodName} not implemented in {typeof(TService).Name}");

        var result = method.Invoke(_service, parameters ?? Array.Empty<object>());
        return await (Task<T>)result!;
    }
}
