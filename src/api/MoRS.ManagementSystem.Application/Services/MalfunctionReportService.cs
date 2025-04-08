using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Application.Interfaces;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Interfaces;

namespace MoRS.ManagementSystem.Application.Services;

public class MalfunctionReportService(IMapper mapper, IMalfunctionReportRepository repository) :
    BaseService<MalfunctionReport, MalfunctionReportResponse, CreateMalfunctionReportRequest, UpdateMalfunctionReportRequest>(mapper, repository),
    IMalfunctionReportService
{

}
