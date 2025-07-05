using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class PaymentProfile : Profile
{
    public PaymentProfile()
    {
        CreateMap<Payment, PaymentResponse>();
        CreateMap<CreatePaymentRequest, Payment>();
    }
}
