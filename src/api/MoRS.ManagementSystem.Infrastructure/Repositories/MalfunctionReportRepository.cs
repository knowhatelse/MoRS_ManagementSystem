using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Repositories;

public class MalfunctionReportRepository(MoRSManagementSystemDbContext context) :
    BaseRepository<MalfunctionReport, MalfunctionReportQuery>(context),
    IMalfunctionReportRepository
{
    protected override IQueryable<MalfunctionReport> ApplyQueryFilters(IQueryable<MalfunctionReport> query, MalfunctionReportQuery? queryFilter)
    {
        if (queryFilter?.RoomId is not null)
        {
            query = query.Where(mr => mr.RoomId == queryFilter.RoomId);
        }

        if (queryFilter?.UserId is not null)
        {
            query = query.Where(mr => mr.ReportedByUserId == queryFilter.UserId);
        }

        if (queryFilter?.Date is not null)
        {
            query = query.Where(mr =>
                mr.Date.Day == queryFilter.Date.Value.Day &&
                mr.Date.Month == queryFilter.Date.Value.Month &&
                mr.Date.Year == queryFilter.Date.Value.Year
            );
        }

        if (queryFilter?.IsArchived is not null)
        {
            query = query.Where(mr => mr.IsArchived == queryFilter.IsArchived);
        }

        if (queryFilter?.IsRoomIncluded == true)
        {
            query = query.Include(mr => mr.Room);
        }

        if (queryFilter?.IsUserIncluded == true)
        {
            query = query.Include(mr => mr.ReportedByUser);
        }


        return base.ApplyQueryFilters(query, queryFilter);
    }
}
