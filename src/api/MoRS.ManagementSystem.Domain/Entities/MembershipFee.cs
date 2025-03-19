using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class MembershipFee
{
    [Key]
    public int Id { get; set; }
    public DateTime PaymentDate { get; set; }
    public float Amount { get; set; }
    public int TransactionId { get; set; }
}
