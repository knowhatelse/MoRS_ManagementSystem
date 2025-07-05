class RoomConstants {
  static const double pageHorizontalPadding = 24.0;
  static const double tableSidePadding = 80.0;
  static const double titleFontSize = 24.0;
  static const double noDataFontSize = 16.0;
  static const double tableHeaderFontSize = 14.0;
  static const double tableRowFontSize = 14.0;
  static const double fabSize = 56.0;
  static const double fabIconSize = 24.0;
  static const double toggleIconSize = 20.0;
  static const double deleteIconSize = 20.0;
  static const double clearIconSize = 18.0;

  static const int nameColumnFlex = 1;
  static const int typeColumnFlex = 1;
  static const int colorColumnFlex = 1;
  static const int statusColumnFlex = 1;
  static const double toggleColumnWidth = 220.0;
  static const double deleteColumnWidth = 60.0;

  static const List<String> roomTypes = ['Studio', 'Room', 'Control Room'];

  static const String pageTitle = 'Prostorije';
  static const String noDataMessage = 'Nema prostorija za prikaz';
  static const String loadingErrorMessage = 'Greška pri učitavanju prostorija. Server ne odgovara';
  static const String deleteErrorMessage = 'Greška pri brisanju prostorije. Server ne odgovara';
  static const String deleteSuccessMessage = 'Prostorija je uspješno obrisana';
  static const String updateErrorMessage = 'Greška pri ažuriranju prostorije. Server ne odgovara';
  static const String updateSuccessMessage = 'Prostorija je uspješno ažurirana';
  static const String createErrorMessage = 'Greška pri kreiranju prostorije. Server ne odgovara';
  static const String createSuccessMessage = 'Prostorija je uspješno kreirana';
  static const String activateSuccessMessage =
      'Prostorija je uspješno aktivirana';
  static const String activateErrorMessage =
      'Greška pri aktiviranju prostorije. Server ne odgovara';
  static const String deactivateSuccessMessage =
      'Prostorija je uspješno deaktivirana. Server ne odgovara';
  static const String deactivateErrorMessage =
      'Greška pri deaktiviranju prostorije. Server ne odgovara';
  static const String refreshTooltip = 'Osvježi';
  static const String deleteTooltip = 'Obriši prostoriju';
  static const String activateTooltip = 'Aktiviraj prostoriju';
  static const String deactivateTooltip = 'Deaktiviraj prostoriju';
  static const String addRoomTooltip = 'Dodaj novu prostoriju';
  static const String cancelButton = 'Otkaži';
  static const String deleteButton = 'Obriši';
  static const String saveButton = 'Sačuvaj';
  static const String createButton = 'Kreiraj';
  static const String deleteConfirmationTitle = 'Potvrda brisanja';
  static const String activateConfirmationTitle = 'Potvrda aktivacije';
  static const String deactivateConfirmationTitle = 'Potvrda deaktivacije';
  static const String editRoomTitle = 'Uredi prostoriju';
  static const String createRoomTitle = 'Kreiraj prostoriju';

  static const String nameHeader = 'Naziv';
  static const String typeHeader = 'Tip';
  static const String colorHeader = 'Boja';
  static const String statusHeader = 'Status';
  static const String toggleHeader = 'Aktiviraj/Deaktiviraj';
  static const String deleteHeader = 'Obriši';

  static const String activeStatus = 'Aktivna';
  static const String inactiveStatus = 'Neaktivna';
  static const String activateButton = 'Aktiviraj';
  static const String deactivateButton = 'Deaktiviraj';

  static const String nameLabel = 'Naziv';
  static const String typeLabel = 'Tip';
  static const String colorLabel = 'Boja';
  static const String nameHint = 'Unesite naziv prostorije';
  static const String typeHint = 'Unesite tip prostorije';
  static const String colorHint = 'Odaberite boju';

  static const String nameRequiredMessage = 'Naziv je obavezan';
  static const String typeRequiredMessage = 'Tip je obavezan';
  static const String colorRequiredMessage = 'Boja je obavezna';
  static const String nameMinLengthMessage =
      'Naziv mora imati najmanje 2 karaktera';
  static const String typeMinLengthMessage =
      'Tip mora imati najmanje 2 karaktera';
  static const String nameMaxLengthMessage =
      'Naziv može imati najviše 50 karaktera';
  static const String typeMaxLengthMessage =
      'Tip može imati najviše 50 karaktera';

  static String deleteConfirmationMessage(String roomName) {
    return 'Da li ste sigurni da želite obrisati prostoriju: '
        '$roomName?';
  }

  static String activateConfirmationMessage(String roomName) {
    return 'Da li ste sigurni da želite aktivirati prostoriju: '
        '$roomName?';
  }

  static String deactivateConfirmationMessage(String roomName) {
    return 'Da li ste sigurni da želite deaktivirati prostoriju: '
        '$roomName?';
  }
}
