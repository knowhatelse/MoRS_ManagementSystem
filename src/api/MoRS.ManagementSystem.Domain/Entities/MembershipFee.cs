using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Domain.Entities;

public class MembershipFee
{
    public int Id { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public MembershipType MembershipType { get; set; }

    public int PaymentId { get; set; }
    public Payment Payment { get; set; } = null!;
}
