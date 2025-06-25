using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.AppointmentType;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAppointmentTypeService :
    IBaseService<AppointmentTypeResponse, CreateAppointmentTypeRequest, EmptyDto, EmptyQuery>
{

}
