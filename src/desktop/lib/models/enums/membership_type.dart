enum MembershipType { mjesecna, godisnja }

extension MembershipTypeExtension on MembershipType {
  String get value {
    switch (this) {
      case MembershipType.mjesecna:
        return 'Mjesecna';
      case MembershipType.godisnja:
        return 'Godisnja';
    }
  }

  static MembershipType fromString(String value) {
    switch (value) {
      case 'Mjesecna':
        return MembershipType.mjesecna;
      case 'Godisnja':
        return MembershipType.godisnja;
      default:
        throw ArgumentError('Invalid MembershipType value: $value');
    }
  }
}
