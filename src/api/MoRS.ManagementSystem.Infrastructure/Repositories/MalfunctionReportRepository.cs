using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class MalfunctionReportRepository(MoRSManagementSystemDbContext context) : BaseRepository<MalfunctionReport>(context), IMalfunctionReportRepository
{

}
