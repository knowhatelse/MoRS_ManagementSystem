using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class EmailRepository(MoRSManagementSystemDbContext context) : BaseRepository<Email>(context), IEmailRepository
{

}
