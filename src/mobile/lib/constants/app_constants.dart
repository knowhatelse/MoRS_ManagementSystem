import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryBlue = Color(0xFF525FE1);
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;

  static const double topBarHeight = 56.0;
  static const double bottomBarHeight = 70.0;
  static const double borderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double navItemSize = 50.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
  );
  static const EdgeInsets bottomNavPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );
  static BoxShadow get topBarShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    offset: const Offset(0, 2),
    blurRadius: 8,
    spreadRadius: 0,
  );

  static BoxShadow get bottomBarShadow => BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    offset: const Offset(0, -2),
    blurRadius: 8,
    spreadRadius: 0,
  );
}

class AppStrings {
  static const List<String> pageTitles = [
    'Obavijesti',
    'Planer',
    'Moji termini',
    'Prijava kvara',
    'Profil',
  ];
  static const String announcements = 'Obavijesti';
  static const String schedule = 'Planer';
  static const String mySchedule = 'Moji termini';
  static const String reportProblem = 'Prijava kvara';
  static const String profile = 'Profil';

  static const String comingSoonMessage =
      'Ova funkcionalnost će biti implementirana uskoro.';
  static const String notifications = 'Notifikacije';
  static const String login = 'Prijava';
  static const String loginButton = 'Prijavi se';
  static const String email = 'Email';
  static const String password = 'Lozinka';
  static const String invalidEmailOrPassword =
      'Neispravna email adresa ili lozinka';
  static const String enterEmail = 'Unesite email adresu';
  static const String enterValidEmail = 'Unesite ispravnu email adresu';
  static const String enterPassword = 'Unesite lozinku';
  static const String unexpectedError =
      'Došlo je do neočekivane greške. Molimo pokušajte ponovo.';

  static const String serverNotResponding =
      'Server ne odgovara. Molimo pokušajte ponovo.';
  static const String connectionTimeout =
      'Veza se prekida zbog dugog čekanja. Provjerite internetsku vezu.';
  static const String noInternetConnection =
      'Nema internetske veze ili server nije dostupan.';
  static const String loadingAnnouncementsFailed =
      'Učitavanje obavijesti nije uspjelo.';
  static const String loadingAppointmentsFailed =
      'Učitavanje termina nije uspjelo.';
  static const String tryAgain = 'Pokušaj ponovo';
  static const String checkConnection = 'Provjerite internetsku vezu';
  static const String serverMaintenance =
      'Server je trenutno u održavanju. Molimo pokušajte kasnije.';

  static const String announcementDetails = 'Detalji o obavijesti';
  static const String author = 'Autor:';
  static const String publishedDate = 'Datum objave:';

  static const String noAppointmentsToday = 'Nema termina za danas.';
  static const String noAppointmentsForDate = 'Nema termina za odabrani datum.';
  static const String appointmentTime = 'Vrijeme:';
  static const String appointmentRoom = 'Sala:';
  static const String appointmentType = 'Tip:';
  static const String appointmentAttendees = 'Polaznici:';
  static const String bookedBy = 'Rezervirao:';
  static const String cancelled = 'Otkazano';
  static const String today = 'Danas';
  static const String tomorrow = 'Sutra';
  static const String users = 'Korisnici';

  static const String newAppointment = 'Novi termin';
  static const String timeFrom = 'Od:';
  static const String timeTo = 'Do:';
  static const String appointmentDate = 'Datum:';
  static const String room = 'Prostorija:';
  static const String appointmentTypeLabel = 'Tip termina:';
  static const String addUser = 'Dodajte korisnika:';
  static const String repeatingAppointment = 'Ponavljajući termin:';
  static const String createAppointment = 'Kreiraj termin';
  static const String cancel = 'Otkaži';
  static const String selectRoom = 'Odaberi prostoriju';
  static const String selectAppointmentType = 'Odaberi tip termina';
  static const String selectUser = 'Odaberi korisnika';
  static const String searchUsers = 'Pretraži korisnike...';
  static const String noUsersFound = 'Nema pronađenih korisnika';
  static const String required = 'Obavezno polje';
  static const String invalidTimeRange =
      'Vrijeme "Od" mora biti prije vremena "Do"';
  static const String appointmentCreated = 'Termin je uspješno kreiran';
  static const String appointmentCreationFailed =
      'Kreiranje termina nije uspjelo';

  static const String description = 'Opis';
  static const String describeTheProblem = 'Opišite problem...';
  static const String selectRoomForReport = 'Odaberite prostoriju';
  static const String submitReport = 'Prijavi kvar';
  static const String reportSubmitted = 'Kvar je uspješno prijavljen';
  static const String reportSubmissionFailed = 'Prijava kvara nije uspjela';
  static const String pleaseSelectRoom = 'Molimo odaberite prostoriju';
  static const String pleaseEnterDescription = 'Molimo unesite opis problema';
  static const String descriptionTooShort =
      'Opis mora imati najmanje 10 znakova';
  static const String descriptionTooLong =
      'Opis može imati najviše 1000 znakova';
  static const String charactersRemaining = 'znakova preostalo';
  static const String charactersExceeded = 'znakova preko limita';

  static const String markAsRead = 'Označi kao pročitano';
  static const String deleteNotification = 'Obriši notifikaciju';
  static const String noNotifications = 'Nema notifikacija';
  static const String notificationDeleted = 'Notifikacija je obrisana';
  static const String notificationMarkedAsRead =
      'Notifikacija je označena kao pročitana';
  static const String errorLoadingNotifications =
      'Greška pri učitavanju notifikacija';
  static const String errorDeletingNotification =
      'Greška pri brisanju notifikacije';
  static const String errorMarkingNotification =
      'Greška pri označavanju notifikacije';
}
