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

  // Individual page titles for const usage
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
      'An unexpected error occurred. Please try again.';
}
