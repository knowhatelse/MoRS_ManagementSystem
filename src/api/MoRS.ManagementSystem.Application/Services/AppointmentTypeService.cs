using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.AppointmentType;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentTypeService(IMapper mapper, IAppointmentTypeRepository appointmentTypeRepository) :
    BaseService<AppointmentType, AppointmentTypeResponse, CreateAppointmentTypeRequest, EmptyDto, EmptyQuery>(mapper, appointmentTypeRepository),
    IAppointmentTypeService
{

}
