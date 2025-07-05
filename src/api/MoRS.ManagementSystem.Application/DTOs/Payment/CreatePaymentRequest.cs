using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Application.DTOs.Payment;

public class CreatePaymentRequest
{
    public decimal Amount { get; set; }
    public PaymentStatus Status { get; set; }
    public PaymentMethod PaymentMethod { get; set; }
    public required string TransactionId { get; set; }
    public int UserId { get; set; }
}
