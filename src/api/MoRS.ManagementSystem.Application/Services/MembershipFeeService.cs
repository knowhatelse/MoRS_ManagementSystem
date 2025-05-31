using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.MembershipFee;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.Services;

public class MembershipFeeService(IMapper mapper, IMembershipFeeRepository repository) :
    BaseService<MembershipFee, MembershipFeeResponse, EmptyDto, EmptyDto, EmptyQuery>(mapper, repository),
    IMembershipFeeService
{

}
