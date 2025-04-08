using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentService(IMapper mapper, IAppointmentRepository repository) :
    BaseService<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest>(mapper, repository),
    IAppointmentService
{

}
