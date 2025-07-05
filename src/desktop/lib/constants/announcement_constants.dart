class AnnouncementConstants {
  static const double pageHorizontalPadding = 24.0;
  static const double tableSidePadding = 80.0;
  static const double titleFontSize = 24.0;
  static const double noDataFontSize = 16.0;
  static const double tableHeaderFontSize = 14.0;
  static const double tableRowFontSize = 14.0;
  static const double fabSize = 56.0;
  static const double fabIconSize = 24.0;
  static const double archiveIconSize = 20.0;
  static const double clearIconSize = 18.0;
  static const double deleteIconSize = 20.0;
  static const int titleColumnFlex = 3;
  static const int dateColumnFlex = 1;
  static const int createdByColumnFlex = 2;
  static const double archiveColumnWidth = 80.0;
  static const double deleteColumnWidth = 60.0;
  static const String pageTitle = 'Objave';
  static const String noDataMessage = 'Nema objava za prikaz';
  static const String loadingErrorMessage = 'Greška pri učitavanju objava. Server ne odgovara';
  static const String archiveErrorMessage = 'Greška pri arhiviranju objave. Server ne odgovara';
  static const String archiveSuccessMessage = 'Objava je uspješno arhivirana';
  static const String unarchiveErrorMessage = 'Greška pri vraćanju objave iz arhive. Server ne odgovara';
  static const String unarchiveSuccessMessage = 'Objava je uspješno vraćena iz arhive';
  static const String createErrorMessage = 'Greška pri kreiranju objave. Server ne odgovara';
  static const String createSuccessMessage = 'Objava je uspješno kreirana';
  static const String clearFiltersLabel = 'Ukloni filtere';
  static const String refreshTooltip = 'Osvježi';
  static const String filterTooltip = 'Filtriraj objave';
  static const String archiveTooltip = 'Arhiviraj objavu';
  static const String unarchiveTooltip = 'Vrati objavu iz arhive';
  static const String createTooltip = 'Kreiraj novu objavu';
  static const String cancelButton = 'Otkaži';
  static const String archiveButton = 'Arhiviraj';
  static const String unarchiveButton = 'Vrati iz arhive';
  static const String createButton = 'Kreiraj';
  static const String deleteButton = 'Obriši';
  static const String archiveConfirmationTitle = 'Potvrda arhiviranja';
  static const String unarchiveConfirmationTitle = 'Potvrda vraćanja iz arhive';
  static const String createAnnouncementTitle = 'Nova objava';
  static const String viewAnnouncementTitle = 'Detalji objave';
  static const String titleHeader = 'Naslov';
  static const String dateHeader = 'Datum';
  static const String createdByHeader = 'Kreirao';
  static const String archiveHeader = 'Arhiviraj';
  static const String deleteHeader = 'Obriši';
  static const String titleFieldLabel = 'Naslov';
  static const String contentFieldLabel = 'Sadržaj';
  static const String titleFieldHint = 'Unesite naslov objave (5-100 znakova)';
  static const String contentFieldHint = 'Unesite sadržaj objave (10-2000 znakova)';
  static const String titleRequiredMessage = 'Naslov je obavezan';
  static const String titleLengthMessage = 'Naslov mora imati između 5 i 100 znakova';
  static const String contentRequiredMessage = 'Sadržaj je obavezan';
  static const String contentLengthMessage = 'Sadržaj mora imati između 10 i 2000 znakova';

  static String archiveConfirmationMessage(
    String title,
    String createdBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite arhivirati objavu "$title"?';
  }

  static String unarchiveConfirmationMessage(
    String title,
    String createdBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite vratiti objavu "$title" iz arhive?';
  }

  static const String deleteTooltip = 'Obriši objavu';
  static const String deleteSuccessMessage = 'Objava je uspješno obrisana';
  static const String deleteErrorMessage = 'Greška pri brisanju objave. Server ne odgovara';
  static const String deleteConfirmationTitle = 'Potvrda brisanja';
  static String deleteConfirmationMessage(
    String title,
    String createdBy,
    String date,
  ) {
    return 'Da li ste sigurni da želite obrisati objavu "$title"?';
  }
}
