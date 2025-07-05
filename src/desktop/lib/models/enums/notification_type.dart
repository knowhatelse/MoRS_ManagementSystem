enum NotificationType {
  informacija,
  hitno,
  podsjetnik,
  upozorenje,
  uspjesno,
  greska,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.informacija:
        return 'Informacija';
      case NotificationType.hitno:
        return 'Hitno';
      case NotificationType.podsjetnik:
        return 'Podsjetnik';
      case NotificationType.upozorenje:
        return 'Upozorenje';
      case NotificationType.uspjesno:
        return 'Uspjesno';
      case NotificationType.greska:
        return 'Greska';
    }
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'Informacija':
        return NotificationType.informacija;
      case 'Hitno':
        return NotificationType.hitno;
      case 'Podsjetnik':
        return NotificationType.podsjetnik;
      case 'Upozorenje':
        return NotificationType.upozorenje;
      case 'Uspjesno':
        return NotificationType.uspjesno;
      case 'Greska':
        return NotificationType.greska;
      default:
        throw ArgumentError('Invalid NotificationType value: $value');
    }
  }
}
