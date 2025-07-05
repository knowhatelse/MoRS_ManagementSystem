using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class EmailRepository(MoRSManagementSystemDbContext context) : BaseRepository<Email, EmptyQuery>(context), IEmailRepository
{

}
