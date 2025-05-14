using MoRS.ManagementSystem.Application.DTOs.Payment;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.DTOs.MembershipFee;

public class MembershipFeeResponse
{
    public int Id { get; set; }

    public DateTime PaymentDate { get; set; }
    public decimal Amount { get; set; }
    public required PaymentStatus Status { get; set; }
    public required PaymentMethod PaymentMethod { get; set; }
    public MembershipType MembershipType { get; set; }
    public required string TransactionId { get; set; }
    public PaymentResponse? Payment { get; set; }
}
