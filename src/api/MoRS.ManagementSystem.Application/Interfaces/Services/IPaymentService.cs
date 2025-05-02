using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Application.Interfaces.Services.BaseInterfaces;

namespace MoRS.ManagementSystem.Application.Interfaces.Services;

public interface IPaymentService : IAddService<PaymentResponse, PaymentRequest>
{

}
