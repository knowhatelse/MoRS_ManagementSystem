using AutoMapper;
using MoRS.ManagementSystem.API.DTOs.MalfunctionReport;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.API.AutoMapperProfiles;

public class MalfunctionReportProfile : Profile
{
    public MalfunctionReportProfile()
    {
        CreateMap<MalfunctionReport, MalfunctionReportResponse>();
        CreateMap<CreateMalfunctionReportProfileRequest, MalfunctionReport>();
    }
}
