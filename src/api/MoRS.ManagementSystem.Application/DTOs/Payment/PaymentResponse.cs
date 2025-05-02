using MoRS.ManagementSystem.Application.DTOs.MembershipFee;
using MoRS.ManagementSystem.Application.DTOs.User;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.DTOs.Payment;

public class PaymentResponse
{
    public int Id { get; set; }

    public DateTime Date { get; set; }
    public decimal Amount { get; set; }
    public PaymentStatus Status { get; set; }
    public PaymentMethod PaymentMethod { get; set; }
    public required string TransactionId { get; set; }
    public UserResponse User { get; set; } = null!;
    public MembershipFeeResponse? MembershipFee { get; set; }
}
