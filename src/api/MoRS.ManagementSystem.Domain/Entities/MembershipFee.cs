using MoRS.ManagementSystem.Domain.Entities.Enums;

namespace MoRS.ManagementSystem.Domain.Entities;

public class MembershipFee
{
    public int Id { get; set; }

    public DateTime PaymentDate { get; set; }
    public decimal Amount { get; set; }
    public required string Status { get; set; }
    public required string PaymentMethod { get; set; }
    public MembershipType MembershipType { get; set; }
    public int TransactionId { get; set; }

    public int PaymentId { get; set; }
    public Payment Payment { get; set; } = null!;
}
