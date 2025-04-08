using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentService(IMapper mapper, IAppointmentRepository repository) :
    BaseService<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest>(mapper, repository),
    IAppointmentService
{

}
