using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class AppointmentRepository(MoRSManagementSystemDbContext context) : BaseRepository<Appointment>(context), IAppointmentRepository
{

}
