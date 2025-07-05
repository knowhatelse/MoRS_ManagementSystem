using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.MembershipFee;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IMembershipFeeService :
    IBaseService<MembershipFeeResponse, EmptyDto, EmptyDto, EmptyQuery>
{

}
