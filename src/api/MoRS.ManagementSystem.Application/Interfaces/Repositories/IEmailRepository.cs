using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories.BaseInterfaces;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Interfaces.Repositories;

public interface IEmailRepository : IBaseRepository<Email, EmptyQuery>
{

}
