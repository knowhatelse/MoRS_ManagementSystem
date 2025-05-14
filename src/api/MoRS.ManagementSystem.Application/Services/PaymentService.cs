using AutoMapper;
using AutoMapper.Execution;
using MoRS.ManagementSystem.Application.DTOs;
using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Application.Filters;
using MoRS.ManagementSystem.Application.Interfaces.Repositories;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.Services;

public class PaymentService(IMapper mapper, IPaymentRepository paymentRepository, IMembershipFeeRepository membershipFeeRepository, INotificationRepository notificationRepository) :
    BaseService<Payment, PaymentResponse, PaymentRequest, EmptyDto, NoQuery>(mapper, paymentRepository),
    IPaymentService
{
    private readonly IMembershipFeeRepository _membershipFeeRepository = membershipFeeRepository;
    private readonly INotificationRepository _notificationRepository = notificationRepository;

    protected override async Task<Task> AfterInsertAsync(PaymentRequest request, Payment entity)
    {
        if (request.Status != PaymentStatus.Zavrseno)
        {
            var failNotification = new Notification
            {
                Title = Messages.PaymentTitle,
                Message = Messages.PaymentMassageFail,
                Type = NotificationType.Greska,
                Date = DateTime.Now,
                UserId = request.UserId
            };

            await _notificationRepository.AddAsync(failNotification);
            return base.AfterInsertAsync(request, entity);
        }


        var newMembershipiFee = new MembershipFee
        {
            CreatedAt = DateTime.Now,
            MembershipType = MembershipType.Mjesecna,
            PaymentId = entity.Id,
        };

        await _membershipFeeRepository.AddAsync(newMembershipiFee);

        var successNotification = new Notification
        {
            Title = Messages.PaymentTitle,
            Message = Messages.PaymentMassageSuccess,
            Type = NotificationType.Uspjesno,
            Date = DateTime.Now,
            UserId = request.UserId
        };

        await _notificationRepository.AddAsync(successNotification);

        return base.AfterInsertAsync(request, entity);
    }
}
