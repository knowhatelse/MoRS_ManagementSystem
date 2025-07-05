enum PaymentStatus { naCekanju, zavrseno, neuspjesno }

extension PaymentStatusExtension on PaymentStatus {
  String get value {
    switch (this) {
      case PaymentStatus.naCekanju:
        return 'NaCekanju';
      case PaymentStatus.zavrseno:
        return 'Zavrseno';
      case PaymentStatus.neuspjesno:
        return 'Neuspjesno';
    }
  }

  static PaymentStatus fromString(String value) {
    switch (value) {
      case 'NaCekanju':
        return PaymentStatus.naCekanju;
      case 'Zavrseno':
        return PaymentStatus.zavrseno;
      case 'Neuspjesno':
        return PaymentStatus.neuspjesno;
      default:
        throw ArgumentError('Invalid PaymentStatus value: $value');
    }
  }
}
