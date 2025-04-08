using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IAppointmentService :
    IGetService<AppointmentResponse>,
    IAddService<AppointmentResponse, CreateAppointmentRequest>,
    IUpdateService<AppointmentResponse, UpdateAppointmentRequest>,
    IDeleteService
{

}
