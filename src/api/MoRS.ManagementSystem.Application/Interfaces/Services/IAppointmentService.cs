using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAppointmentService :
    IBaseService<AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentQuery>
{

}
