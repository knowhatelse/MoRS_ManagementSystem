enum NotificationType {
  informacija,
  hitno,
  podsjetnik,
  upozorenje,
  uspjesno,
  greska;

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'informacija':
        return NotificationType.informacija;
      case 'hitno':
        return NotificationType.hitno;
      case 'podsjetnik':
        return NotificationType.podsjetnik;
      case 'upozorenje':
        return NotificationType.upozorenje;
      case 'uspjesno':
        return NotificationType.uspjesno;
      case 'greska':
        return NotificationType.greska;
      default:
        return NotificationType.informacija;
    }
  }

  String toJson() {
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
}
