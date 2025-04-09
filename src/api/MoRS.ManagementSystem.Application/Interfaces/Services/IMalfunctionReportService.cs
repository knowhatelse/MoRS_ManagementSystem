using MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IMalfunctionReportService :
    IGetService<MalfunctionReportResponse, MalfunctionReportQuery>,
    IAddService<MalfunctionReportResponse, CreateMalfunctionReportRequest>,
    IUpdateService<MalfunctionReportResponse, UpdateMalfunctionReportRequest>,
    IDeleteService
{

}
