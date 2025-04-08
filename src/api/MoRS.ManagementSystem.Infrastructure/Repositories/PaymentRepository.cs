using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class PaymentRepository(MoRSManagementSystemDbContext context) : BaseRepository<Payment>(context), IPaymentRepository
{

}
