using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IAppointmentService :
    IGetService<AppointmentResponse>,
    IAddService<AppointmentResponse, CreateAppointmentRequest>,
    IUpdateService<AppointmentResponse, UpdateAppointmentRequest>,
    IDeleteService
{

}
