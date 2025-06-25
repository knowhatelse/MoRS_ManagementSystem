class PlanerConstants {
  static const double pageHorizontalPadding = 24.0;
  static const double tableSidePadding = 80.0;
  static const double titleFontSize = 24.0;
  static const double noDataFontSize = 16.0;
  static const double tableHeaderFontSize = 14.0;
  static const double tableRowFontSize = 14.0;
  static const double fabSize = 56.0;
  static const double fabIconSize = 24.0;
  static const double deleteIconSize = 20.0;
  static const double clearIconSize = 18.0;

  static const int appointmentTypeColumnFlex = 2;
  static const int roomColumnFlex = 2;
  static const int dateColumnFlex = 1;
  static const int timeColumnFlex = 1;
  static const int userColumnFlex = 2;
  static const double deleteColumnWidth = 60.0;

  static const String pageTitle = 'Svi termini';
  static const String noDataMessage = 'Nema termina za prikaz';
  static const String loadingErrorMessage = 'Greška pri učitavanju termina';
  static const String deleteErrorMessage = 'Greška pri brisanju termina';
  static const String deleteSuccessMessage = 'Termin je uspješno obrisan';
  static const String clearFiltersLabel = 'Ukloni filtere';
  static const String refreshTooltip = 'Osvježi';
  static const String deleteTooltip = 'Obriši termin';
  static const String cancelButton = 'Otkaži';
  static const String deleteButton = 'Obriši';
  static const String deleteConfirmationTitle = 'Potvrda brisanja';

  static String deleteConfirmationMessage(
    String typeName,
    String roomName,
    String dateTime,
  ) {
    return 'Da li ste sigurni da želite obrisati termin:\\n\\n'
        '$typeName\\n'
        '$roomName\\n'
        '$dateTime?';
  }
}
