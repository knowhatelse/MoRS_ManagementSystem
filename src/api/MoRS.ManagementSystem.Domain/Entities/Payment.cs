using System.ComponentModel.DataAnnotations;

namespace MoRS.ManagementSystem.Domain.Entities;

public class Payment
{
    [Key]
    public int Id { get; set; }
    public DateTime Date { get; set; }
    public float Amount { get; set; }
    public required string Status { get; set; }
    public required string PaymentMethod { get; set; }
    public int TransactionId { get; set; }
}
