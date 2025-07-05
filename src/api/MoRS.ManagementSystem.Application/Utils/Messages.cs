namespace MoRS.ManagementSystem.Application.Utils;

public static class Messages
{
    public const string TimeSlotConflict = "Termin u ovoj prostoriji već postoji u odabranom vremenskom terminu";
    public const string EmailAlreadyExists = "Korisnik sa unesenom email adresom već postoji u sistemu";
    public const string PhoneNumberAlreadyExists = "Korisnik sa unesenim brojem telefona već postoji u sistemu";
    public const string InvalidCredentials = "Nesipravana email adresa ili lozinka";

    public const string PaymentTitle = "Clanarina";
    public const string PaymentMassageSuccess = "Uspijesno ste platili clanarinu!";
    public const string PaymentMassageFail = "Placanje clanarine je bilo neuspjiesno...";

    public const string UserRestricterd = "Ogranicenje naloga";
    public const string UserRestrictedTrue = "Vas nalog je trenutno blokiran.";
    public const string UserRestrictedFalse = "Vas nalog je odblokiran."; 
    public const string AppointmentOutsideAllowedHours = "Termini se mogu zakazati samo između 08:00 i 00:00 sati";
    public const string AppointmentDurationTooShort = "Termin mora trajati najmanje 30 minuta";
    public const string AppointmentDurationTooLong = "Termin ne može trajati duže od 3 sata";
    public const string AppointmentInvalidTimeRange = "Nepravilan vremenski raspon termina";

}
