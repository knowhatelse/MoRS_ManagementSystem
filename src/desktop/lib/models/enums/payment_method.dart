enum PaymentMethod { kreditnaKartica, payPal, bankovniTransfer, gotovina }

extension PaymentMethodExtension on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.kreditnaKartica:
        return 'KreditnaKartica';
      case PaymentMethod.payPal:
        return 'PayPal';
      case PaymentMethod.bankovniTransfer:
        return 'BankovniTransfer';
      case PaymentMethod.gotovina:
        return 'Gotovina';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'KreditnaKartica':
        return PaymentMethod.kreditnaKartica;
      case 'PayPal':
        return PaymentMethod.payPal;
      case 'BankovniTransfer':
        return PaymentMethod.bankovniTransfer;
      case 'Gotovina':
        return PaymentMethod.gotovina;
      default:
        throw ArgumentError('Invalid PaymentMethod value: $value');
    }
  }
}
