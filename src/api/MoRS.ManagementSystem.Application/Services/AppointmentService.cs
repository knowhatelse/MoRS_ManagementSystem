using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentService(IMapper mapper, IAppointmentRepository repository) :
    BaseService<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentQuery>(mapper, repository),
    IAppointmentService
{
    private readonly IMapper _mapper = mapper;
    private readonly IAppointmentRepository _repository = repository;

    public override async Task<AppointmentResponse> AddAsync(CreateAppointmentRequest request)
    {
        var query = new AppointmentQuery
        {
            Date = request.AppointmentSchedule?.Date,
            IsAppointmentScheduleIncluded = true,
            IsRoomIncluded = true,
            IsCancelled = false,
            RoomId = request.RoomId,
        };

        var existingAppointment = await _repository.GetAsync(query);
        var incomingAppointment = _mapper.Map<Appointment>(request);

        foreach (var appointment in existingAppointment)
        {
            if (TimeSlotValidator.IsValidTimeSlot(appointment.AppointmentSchedule?.Time, incomingAppointment.AppointmentSchedule?.Time))
            {
                throw new InvalidOperationException(ErrorMessages.TimeSlotConflict);
            }
        }

        return await base.AddAsync(request);
    }
}
