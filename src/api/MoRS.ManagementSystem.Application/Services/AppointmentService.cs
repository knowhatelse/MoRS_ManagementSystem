using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Appointment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.Services;

public class AppointmentService(IMapper mapper, IAppointmentRepository appointmentRepository, IUserRepository userRepository, INotificationRepository notificationRepository, IRoomRepository roomRepository) :
    BaseService<Appointment, AppointmentResponse, CreateAppointmentRequest, UpdateAppointmentRequest, AppointmentQuery>(mapper, appointmentRepository),
    IAppointmentService
{
    private readonly IMapper _mapper = mapper;
    private readonly IAppointmentRepository _appointmentRepository = appointmentRepository;
    private readonly IUserRepository _userRepository = userRepository;
    private readonly INotificationRepository _notificationRepository = notificationRepository;
    private readonly IRoomRepository _roomRepository = roomRepository;

    protected override async Task BeforeInsertAsync(CreateAppointmentRequest request, Appointment entity)
    {
        if (request.AppointmentSchedule?.Date != null)
        {
            entity.DayOfOccurrance = request.AppointmentSchedule.Date.DayOfWeek.ToString();

            if (request.IsRepeating)
            {
                entity.RepeatingDayOfWeek = request.AppointmentSchedule.Date.DayOfWeek;
            }
        }

        if (request.AppointmentSchedule?.Time != null)
        {
            var timeSlot = _mapper.Map<TimeSlot>(request.AppointmentSchedule.Time);

            if (!TimeSlotValidator.IsValidTimeRange(timeSlot))
            {
                throw new InvalidOperationException(Messages.AppointmentInvalidTimeRange);
            }

            if (!TimeSlotValidator.IsWithinAllowedHours(timeSlot))
            {
                throw new InvalidOperationException(Messages.AppointmentOutsideAllowedHours);
            }

            if (!TimeSlotValidator.IsValidDuration(timeSlot))
            {
                var duration = timeSlot.TimeTo - timeSlot.TimeFrom;
                if (duration < TimeSpan.Zero)
                {
                    duration = duration.Add(new TimeSpan(24, 0, 0));
                }

                if (duration < new TimeSpan(0, 30, 0))
                {
                    throw new InvalidOperationException(Messages.AppointmentDurationTooShort);
                }
                else
                {
                    throw new InvalidOperationException(Messages.AppointmentDurationTooLong);
                }
            }
        }

        if (entity.IsRepeating && request.AppointmentSchedule?.Date != null)
        {
            entity.RepeatingDayOfWeek = request.AppointmentSchedule.Date.DayOfWeek;
        }

        if (request.AttendeesIds != null && request.AttendeesIds.Count > 0)
        {
            var attendees = await _userRepository.GetAsync(new UserQuery { Ids = request.AttendeesIds });
            entity.Attendees = [.. attendees];
        }

        await ValidateNoConflictingAppointments(request, entity);
    }

    private async Task ValidateNoConflictingAppointments(CreateAppointmentRequest request, Appointment newAppointment)
    {
        if (request.AppointmentSchedule?.Date == null || request.AppointmentSchedule.Time == null)
            return;

        var appointmentDate = request.AppointmentSchedule.Date;
        var dayOfWeek = appointmentDate.DayOfWeek; var incomingTimeSlot = _mapper.Map<TimeSlot>(request.AppointmentSchedule.Time);

        var query = new AppointmentQuery
        {
            IsAppointmentScheduleIncluded = true,
            IsRoomIncluded = true,
            IsCancelled = false,
            RoomId = request.RoomId,
        }; var allAppointments = await _appointmentRepository.GetAsync(query);

        var conflictingAppointments = allAppointments.Where(appointment =>
            TimeSlotValidator.IsOccurringOnDate(appointment, appointmentDate));

        foreach (var appointment in conflictingAppointments)
        {
            if (appointment.AppointmentSchedule?.Time != null &&
                TimeSlotValidator.IsValidTimeSlot(appointment.AppointmentSchedule.Time, incomingTimeSlot))
            {
                if (appointment.IsRepeating)
                {
                    throw new InvalidOperationException(
                        $"{Messages.TimeSlotConflict} (Ponavljajući termin svaki {appointment.RepeatingDayOfWeek ?? dayOfWeek})");
                }
                else
                {
                    throw new InvalidOperationException(Messages.TimeSlotConflict);
                }
            }
        }
    }
    protected override async Task<IEnumerable<Appointment>> AfterGetAsync(IEnumerable<Appointment> entities, AppointmentQuery? queryFilter = null)
    {
        var appointments = entities.ToList();

        if (queryFilter?.Date.HasValue == true)
        {
            var targetDate = queryFilter.Date.Value;
            var targetDayOfWeek = targetDate.DayOfWeek; var targetDayName = targetDayOfWeek.ToString();

            var relevantAppointments = new List<Appointment>(); foreach (var appointment in appointments)
            {
                if (appointment.IsCancelled && queryFilter.IsCancelled != true)
                    continue;
                if (TimeSlotValidator.IsOccurringOnDate(appointment, targetDate))
                {
                    if (appointment.IsRepeating && appointment.AppointmentSchedule != null)
                    {
                        var appointmentCopy = new Appointment
                        {
                            Id = appointment.Id,
                            IsRepeating = appointment.IsRepeating,
                            IsCancelled = appointment.IsCancelled,
                            RepeatingDayOfWeek = appointment.RepeatingDayOfWeek,
                            DayOfOccurrance = appointment.DayOfOccurrance,
                            AppointmentSchedule = new AppointmentSchedule
                            {
                                Id = appointment.AppointmentSchedule.Id,
                                Date = targetDate,
                                Time = appointment.AppointmentSchedule.Time
                            },
                            RoomId = appointment.RoomId,
                            Room = appointment.Room,
                            AppointmentTypeId = appointment.AppointmentTypeId,
                            AppointmentType = appointment.AppointmentType,
                            BookedByUserId = appointment.BookedByUserId,
                            BookedByUser = appointment.BookedByUser,
                            Attendees = appointment.Attendees
                        };
                        relevantAppointments.Add(appointmentCopy);
                    }
                    else
                    {
                        relevantAppointments.Add(appointment);
                    }
                }
            }

            return await Task.FromResult(relevantAppointments);
        }
        else if (queryFilter?.DateFrom.HasValue == true || queryFilter?.DateTo.HasValue == true)
        {
            var dateFrom = queryFilter.DateFrom ?? DateOnly.MinValue;
            var dateTo = queryFilter.DateTo ?? DateOnly.MaxValue;

            var relevantAppointments = new List<Appointment>();

            foreach (var appointment in appointments)
            {
                if (appointment.IsCancelled && queryFilter.IsCancelled != true)
                    continue;

                if (appointment.IsRepeating && appointment.RepeatingDayOfWeek.HasValue)
                {
                    var occurrences = GetRepeatingAppointmentOccurrences(appointment, dateFrom, dateTo);
                    relevantAppointments.AddRange(occurrences);
                }
                else if (appointment.AppointmentSchedule?.Date >= dateFrom &&
                         appointment.AppointmentSchedule?.Date <= dateTo)
                {
                    relevantAppointments.Add(appointment);
                }
            }

            return await Task.FromResult(relevantAppointments);
        }
        else
        {
            if (queryFilter?.IsCancelled != true)
            {
                appointments = appointments.Where(a => !a.IsCancelled).ToList();
            }

            return await Task.FromResult(appointments);
        }
    }

    private static List<Appointment> GetRepeatingAppointmentOccurrences(Appointment repeatingAppointment, DateOnly dateFrom, DateOnly dateTo)
    {
        var occurrences = new List<Appointment>();

        if (repeatingAppointment.AppointmentSchedule?.Date == null ||
            !repeatingAppointment.RepeatingDayOfWeek.HasValue)
            return occurrences;

        var startDate = repeatingAppointment.AppointmentSchedule.Date;
        var targetDayOfWeek = repeatingAppointment.RepeatingDayOfWeek.Value;

        var currentDate = dateFrom;

        while (currentDate <= dateTo)
        {
            if (currentDate >= startDate && currentDate.DayOfWeek == targetDayOfWeek)
            {
                var occurrence = new Appointment
                {
                    Id = repeatingAppointment.Id,
                    IsRepeating = repeatingAppointment.IsRepeating,
                    IsCancelled = repeatingAppointment.IsCancelled,
                    RepeatingDayOfWeek = repeatingAppointment.RepeatingDayOfWeek,
                    DayOfOccurrance = repeatingAppointment.DayOfOccurrance,
                    AppointmentSchedule = new AppointmentSchedule
                    {
                        Id = repeatingAppointment.AppointmentSchedule.Id,
                        Date = currentDate,
                        Time = repeatingAppointment.AppointmentSchedule.Time
                    },
                    RoomId = repeatingAppointment.RoomId,
                    Room = repeatingAppointment.Room,
                    AppointmentTypeId = repeatingAppointment.AppointmentTypeId,
                    AppointmentType = repeatingAppointment.AppointmentType,
                    BookedByUserId = repeatingAppointment.BookedByUserId,
                    BookedByUser = repeatingAppointment.BookedByUser,
                    Attendees = repeatingAppointment.Attendees
                };
                occurrences.Add(occurrence);
            }

            currentDate = currentDate.AddDays(1);
        }

        return occurrences;
    }

    protected override async Task AfterInsertAsync(CreateAppointmentRequest request, Appointment entity)
    {
        var attendees = request.AttendeesIds;
        var bookedBy = await _userRepository.GetByIdAsync(request.BookedByUserId);
        var room = await _roomRepository.GetByIdAsync(request.RoomId);

        foreach (var a in attendees!)
        {
            var failNotification = new Notification
            {
                Title = "Dodani ste na termin",
                Message = $"{bookedBy!.Name} {bookedBy.Surname} vas je dodao/la na termin zakazan za {request.AppointmentSchedule!.Date} u {room!.Name}.",
                Type = NotificationType.Podsjetnik,
                Date = DateTime.Now,
                UserId = a
            };


            await _notificationRepository.AddAsync(failNotification);
        }
    }
}
