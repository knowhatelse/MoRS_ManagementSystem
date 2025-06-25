class PaymentResponse {
  final int id;
  final DateTime date;
  final double amount;
  final int status;
  final int paymentMethod;
  final String transactionId;
  final Map<String, dynamic>? user;

  PaymentResponse({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.transactionId,
    this.user,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as int,
      paymentMethod: json['paymentMethod'] as int,
      transactionId: json['transactionId'] as String,
      user: json['user'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
      'user': user,
    };
  }
}
