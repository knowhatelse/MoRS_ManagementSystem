using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Payment
{
    public int Id { get; set; }

    public DateTime Date { get; set; } = DateTime.Now;
    public decimal Amount { get; set; }
    public PaymentStatus Status { get; set; }
    public PaymentMethod PaymentMethod { get; set; }
    public int TransactionId { get; set; }

    public int UserId { get; set; }
    public User User { get; set; } = null!;

    public ICollection<MembershipFee> MembershipFees { get; set; } = [];
}
