using AutoMapper;
using AutoMapper.Execution;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.Services;

public class PaymentService(IMapper mapper, IPaymentRepository paymentRepository, IMembershipFeeRepository membershipFeeRepository) :
    BaseService<Payment, PaymentResponse, PaymentRequest, EmptyDto, NoQuery>(mapper, paymentRepository),
    IPaymentService
{
    private readonly IMembershipFeeRepository _membershipFeeRepository = membershipFeeRepository;

    protected override async Task<Task> AfterInsertAsync(PaymentRequest request, Payment entity)
    {
        var newMembershipiFee = new MembershipFee
        {
            CreatedAt = DateTime.Now,
            MembershipType = MembershipType.Mjesecna,
            PaymentId = entity.Id,
        };

        await _membershipFeeRepository.AddAsync(newMembershipiFee);
        return base.AfterInsertAsync(request, entity);
    }
}
