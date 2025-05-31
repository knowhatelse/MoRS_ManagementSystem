using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentService(IMapper mapper, IAppointmentRepository appointmentRepository, IUserRepository userRepository) :
    BaseService<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentQuery>(mapper, appointmentRepository),
    IAppointmentService
{
    private readonly IMapper _mapper = mapper;
    private readonly IAppointmentRepository _appointmentRepository = appointmentRepository;
    private readonly IUserRepository _userRepository = userRepository;


    protected override async Task BeforeInsertAsync(CreateAppointmentRequest request, Appointment entity)
    {
        var query = new AppointmentQuery
        {
            Date = request.AppointmentSchedule?.Date,
            IsAppointmentScheduleIncluded = true,
            IsRoomIncluded = true,
            IsCancelled = false,
            RoomId = request.RoomId,
        };

        var existingAppointment = await _appointmentRepository.GetAsync(query);
        var incomingAppointment = _mapper.Map<Appointment>(request);

        foreach (var appointment in existingAppointment)
        {

            if (TimeSlotValidator.IsValidTimeSlot(appointment.AppointmentSchedule?.Time, incomingAppointment.AppointmentSchedule?.Time))
            {
                throw new InvalidOperationException(Messages.TimeSlotConflict);
            }
        }
    }

    protected override async Task<IEnumerable<Appointment>> AfterGetAsync(IEnumerable<Appointment> entities, AppointmentQuery? queryFilter = null)
    {
        var currentDate = queryFilter?.Date ?? DateOnly.FromDateTime(DateTime.Today);

        foreach (var appointment in entities)
        {
            if (appointment.IsRepeating && appointment.AppointmentSchedule != null)
            {
                appointment.AppointmentSchedule.Date = currentDate;
            }
        }

        return await Task.FromResult(entities);
    }
}
