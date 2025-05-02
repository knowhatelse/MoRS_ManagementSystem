using AutoMapper;
using MoRS.ManagementSystem.Application.Interfaces.Repositories.BaseInterfaces;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Services;

public abstract class BaseService<TEntity, TResponse, TCreateRequest, TUpdateRequest, TQueryFilter>(IMapper mapper, IBaseRepository<TEntity, TQueryFilter> repository) :
    IGetService<TResponse, TQueryFilter>, IAddService<TResponse, TCreateRequest>, IUpdateService<TResponse, TUpdateRequest>, IDeleteService
    where TQueryFilter : class
{
    private readonly IMapper _mapper = mapper;
    private readonly IBaseRepository<TEntity, TQueryFilter> _repository = repository;

    public virtual async Task<TResponse> AddAsync(TCreateRequest request)
    {
        var entity = _mapper.Map<TEntity>(request);
        await BeforeInsertAsync(request, entity);
        var response = await _repository.AddAsync(entity);
        return _mapper.Map<TResponse>(response);
    }

    public virtual async Task<bool> DeleteAsync(int id)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity is null)
        {
            return false;
        }

        return await _repository.DeleteAsync(entity);
    }

    public virtual async Task<IEnumerable<TResponse>> GetAsync(TQueryFilter? queryFilter = null)
    {
        var entities = await _repository.GetAsync(queryFilter);
        entities = await AfterGetAsync(entities, queryFilter);
        return _mapper.Map<IEnumerable<TResponse>>(entities);
    }

    public virtual async Task<TResponse?> GetByIdAsync(int id)
    {
        var entity = await _repository.GetByIdAsync(id);
        return _mapper.Map<TResponse>(entity);
    }

    public virtual async Task<TResponse?> UpdateAsync(int id, TUpdateRequest request)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity is null)
        {
            return _mapper.Map<TResponse>(entity);
        }

        var result = await _repository.UpdateAsync(entity);
        return _mapper.Map<TResponse>(result);
    }

    protected virtual Task BeforeInsertAsync(TCreateRequest request, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual Task AfterInsertAsync(TCreateRequest request, TEntity entity)
    {
        return Task.CompletedTask;
    }

    protected virtual Task<IEnumerable<TEntity>> AfterGetAsync(IEnumerable<TEntity> entities, TQueryFilter? queryFilter = null)
    {
        return Task.FromResult(entities);
    }
}
