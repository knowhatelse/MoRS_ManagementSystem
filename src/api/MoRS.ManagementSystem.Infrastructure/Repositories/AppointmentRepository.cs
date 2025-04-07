using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class AppointmentRepository(MoRSManagementSystemDbContext context) : BaseRepository<Appointment>(context), IAppointmentRepository
{

}
