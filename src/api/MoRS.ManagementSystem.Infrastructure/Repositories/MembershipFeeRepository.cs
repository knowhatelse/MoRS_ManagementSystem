using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;
using MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class MembershipFeeRepository(MoRSManagementSystemDbContext context) : BaseRepository<MembershipFee>(context), IMembershipFeeRepository
{

}
