using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.MembershipFee;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class MembershipFeeProfile : Profile
{
    public MembershipFeeProfile()
    {
        CreateMap<MembershipFee, MembershipFeeResponse>();
    }
}
