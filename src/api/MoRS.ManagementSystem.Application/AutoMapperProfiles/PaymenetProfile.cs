using AutoMapper;
using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Application.AutoMapperProfiles;

public class PaymenetProfile : Profile
{
    public PaymenetProfile()
    {
        CreateMap<CreatePaymentRequest, Payment>();
    }
}
