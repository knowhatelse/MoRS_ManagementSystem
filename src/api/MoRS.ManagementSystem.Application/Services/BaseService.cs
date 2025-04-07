using AutoMapper;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;
using MoRS.ManagementSystem.Domain.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class BaseService<TEntity, TResponse, TCreateRequest, TUpdateRequest>(IMapper mapper, IBaseRepository<TEntity> repository) :
    IGetService<TResponse>, IAddService<TResponse, TCreateRequest>, IUpdateService<TResponse, TUpdateRequest>, IDeleteService
{
    private readonly IMapper _mapper = mapper;
    private readonly IBaseRepository<TEntity> _repository = repository;

    public async Task<TResponse> AddAsync(TCreateRequest request)
    {
        var entity = _mapper.Map<TEntity>(request);
        var response = await _repository.AddAsync(entity);
        return _mapper.Map<TResponse>(response);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity is null)
        {
            return false;
        }

        return await _repository.DeleteAsync(entity);
    }

    public async Task<IEnumerable<TResponse>> GetAsync()
    {
        var entities = await _repository.GetAsync();
        return _mapper.Map<IEnumerable<TResponse>>(entities);
    }

    public async Task<TResponse?> GetByIdAsync(int id)
    {
        var entity = await _repository.GetByIdAsync(id);
        return _mapper.Map<TResponse>(entity);
    }

    public async Task<TResponse?> UpdateAsync(int id, TUpdateRequest request)
    {
        var entity = await _repository.GetByIdAsync(id);

        if (entity is null)
        {
            return _mapper.Map<TResponse>(entity);
        }

        var result = await _repository.UpdateAsync(entity);
        return _mapper.Map<TResponse>(result);
    }
}
