import 'package:flutter/material.dart';

class UsersPageConstants {
  static const String createUserTitle = 'Kreiraj korisnika';
  static const String editUserTitle = 'Uredi korisnika';
  static const String searchUserTitle = 'Pretraži korisnika';

  static const List<Map<String, dynamic>> userRoles = [
    {'label': 'Osoblje', 'id': 2},
    {'label': 'Polaznik', 'id': 3},
  ];

  static const defaultProfileBackgroundColor = Color(0xFF525FE1);

  static const String columnProfilePicture = 'Profilna slika';
  static const String columnName = 'Ime';
  static const String columnSurname = 'Prezime';
  static const String columnEmail = 'Email';
  static const String columnPhone = 'Broj telefona';
  static const String columnRole = 'Tip korisnika';
}
