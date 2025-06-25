class CreatePaymentRequest {
  final double amount;
  final int status; 
  final int
  paymentMethod;
  final String transactionId;
  final int userId;

  CreatePaymentRequest({
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Amount': amount,
      'Status': status,
      'PaymentMethod': paymentMethod,
      'TransactionId': transactionId,
      'UserId': userId,
    };
  }
}
