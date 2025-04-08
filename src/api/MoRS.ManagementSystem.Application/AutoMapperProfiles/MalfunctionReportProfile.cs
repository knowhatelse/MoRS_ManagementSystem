using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class MalfunctionReportProfile : Profile
{
    public MalfunctionReportProfile()
    {
        CreateMap<MalfunctionReport, MalfunctionReportResponse>();
        CreateMap<CreateMalfunctionReportRequest, MalfunctionReport>();
        CreateMap<UpdateMalfunctionReportRequest, MalfunctionReport>();
    }
}
