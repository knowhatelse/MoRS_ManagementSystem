using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class AppointmentRepository(MoRSManagementSystemDbContext context) : BaseRepository<Appointment, AppointmentQuery>(context), IAppointmentRepository
{
    protected override IQueryable<Appointment> ApplyQueryFilters(IQueryable<Appointment> query, AppointmentQuery? queryFilter)
    {
        if (queryFilter?.Date is not null)
        {
            query = query.Include(a => a.AppointmentSchedule).Where(a =>
                a.AppointmentSchedule != null &&
                a.AppointmentSchedule.Date == queryFilter.Date
            );
        }

        if (queryFilter?.DateFrom is not null)
        {
            query = query.Include(a => a.AppointmentSchedule).Where(a =>
                a.AppointmentSchedule != null &&
                a.AppointmentSchedule.Date >= queryFilter.DateFrom
            );
        }

        if (queryFilter?.DateTo is not null)
        {
            query = query.Include(a => a.AppointmentSchedule).Where(a =>
                a.AppointmentSchedule != null &&
                a.AppointmentSchedule.Date <= queryFilter.DateTo
            );
        }

        if (queryFilter?.RoomId is not null)
        {
            query = query.Where(a => a.RoomId == queryFilter.RoomId);

        }

        if (queryFilter?.BookedByUserId is not null)
        {
            query = query.Where(a => a.BookedByUserId == queryFilter.BookedByUserId);

        }

        if (queryFilter?.AttendeeId is not null)
        {
            query = query.Include(a => a.Attendees).Where(a => a.Attendees.Any(u => u.Id == queryFilter.AttendeeId));
        }

        if (queryFilter?.IsCancelled is not null)
        {
            query = query.Where(a => a.IsCancelled == queryFilter.IsCancelled);
        }

        if (queryFilter?.IsRepeating is not null)
        {
            query = query.Where(a => a.IsCancelled == queryFilter.IsCancelled);
        }

        if (queryFilter?.IsRoomIncluded == true)
        {
            query = query.Include(a => a.Room);
        }

        if (queryFilter?.IsAppointmentTypeIncluded == true)
        {
            query = query.Include(a => a.AppointmentType);
        }

        if (queryFilter?.IsAppointmentScheduleIncluded == true)
        {
            query = query.Include(a => a.AppointmentSchedule).ThenInclude(s => s!.Time);
        }

        if (queryFilter?.IsUserIncluded == true)
        {
            query = query.Include(a => a.BookedByUser).ThenInclude(u => u.ProfilePicture);
        }

        if (queryFilter?.AreAttendeesIncluded == true)
        {
            query = query.Include(a => a.Attendees).ThenInclude(u => u.ProfilePicture);
        }

        return base.ApplyQueryFilters(query, queryFilter);
    }
}
