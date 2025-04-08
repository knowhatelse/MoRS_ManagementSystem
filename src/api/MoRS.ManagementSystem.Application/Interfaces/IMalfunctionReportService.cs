using MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Application.Interfaces.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces;

public interface IMalfunctionReportService :
    IGetService<MalfunctionReportResponse>, 
    IAddService<MalfunctionReportResponse, CreateMalfunctionReportRequest>,
    IUpdateService<MalfunctionReportResponse, UpdateMalfunctionReportRequest>,
    IDeleteService
{

}
