using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class MalfunctionReportService(IMapper mapper, IMalfunctionReportRepository repository) :
    BaseService<MalfunctionReport, MalfunctionReportResponse, CreateMalfunctionReportRequest, UpdateMalfunctionReportRequest>(mapper, repository),
    IMalfunctionReportService
{

}
