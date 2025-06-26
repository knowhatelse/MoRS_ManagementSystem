class ReportConstants {
  static const double pageHorizontalPadding = 24.0;
  static const double tableSidePadding = 80.0;
  static const double titleFontSize = 24.0;
  static const double noDataFontSize = 16.0;
  static const double tableHeaderFontSize = 14.0;
  static const double tableRowFontSize = 14.0;
  static const double fabSize = 56.0;
  static const double fabIconSize = 24.0;
  static const double archiveIconSize = 20.0;
  static const double deleteIconSize = 20.0;
  static const double clearIconSize = 18.0;

  static const int roomColumnFlex = 2;
  static const int reportedByColumnFlex = 2;
  static const int dateColumnFlex = 1;
  static const int timeColumnFlex = 1;
  static const double archiveColumnWidth = 80.0;
  static const double deleteColumnWidth = 60.0;

  static const String pageTitle = 'Prijave kvarova';
  static const String noDataMessage = 'Nema prijava kvarova za prikaz';
  static const String loadingErrorMessage =
      'Greška pri učitavanju prijava kvarova';
  static const String archiveErrorMessage =
      'Greška pri arhiviranju prijave kvara';
  static const String archiveSuccessMessage =
      'Prijava kvara je uspješno arhivirana';
  static const String unarchiveErrorMessage =
      'Greška pri vraćanju prijave kvara iz arhive';
  static const String unarchiveSuccessMessage =
      'Prijava kvara je uspješno vraćena iz arhive';
  static const String deleteErrorMessage = 'Greška pri brisanju prijave kvara';
  static const String deleteSuccessMessage =
      'Prijava kvara je uspješno obrisana';
  static const String clearFiltersLabel = 'Ukloni filtere';
  static const String refreshTooltip = 'Osvježi';
  static const String archiveTooltip = 'Arhiviraj prijavu kvara';
  static const String unarchiveTooltip = 'Vrati prijavu kvara iz arhive';
  static const String deleteTooltip = 'Obriši prijavu kvara';
  static const String cancelButton = 'Otkaži';
  static const String archiveButton = 'Arhiviraj';
  static const String unarchiveButton = 'Vrati iz arhive';
  static const String deleteButton = 'Obriši';
  static const String archiveConfirmationTitle = 'Potvrda arhiviranja';
  static const String unarchiveConfirmationTitle = 'Potvrda vraćanja iz arhive';
  static const String deleteConfirmationTitle = 'Potvrda brisanja';

  static const String roomHeader = 'Prostorija';
  static const String reportedByHeader = 'Prijavio';
  static const String dateHeader = 'Datum';
  static const String timeHeader = 'Vrijeme';
  static const String archiveHeader = 'Arhiviraj';
  static const String deleteHeader = 'Obriši';

  static String archiveConfirmationMessage(
    String roomName,
    String reportedBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite arhivirati odabranu prijavu kvara?';
  }

  static String unarchiveConfirmationMessage(
    String roomName,
    String reportedBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite vratiti odabranu prijavu kvara iz arhive?';
  }

  static String deleteConfirmationMessage(
    String roomName,
    String reportedBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite obrisati odabranu prijavu kvara?';
  }
}
