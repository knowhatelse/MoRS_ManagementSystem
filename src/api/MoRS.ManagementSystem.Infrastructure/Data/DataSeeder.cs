using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;

namespace MoRS.ManagementSystem.Infrastructure.Data;

public class DataSeeder(MoRSManagementSystemDbContext context, ILogger<DataSeeder> logger)
{
    private readonly MoRSManagementSystemDbContext _context = context;
    private readonly ILogger<DataSeeder> _logger = logger;

    private byte[]? _passwordHash;
    private byte[]? _passwordSalt;
    private static readonly int[] sourceArray = [9, 10, 11, 12, 13, 14];

    public async Task SeedData()
    {
        var defaultPassword = "Test123$";

        PasswordHelper.CreatePasswordHash(defaultPassword, out byte[] passwordHash, out byte[] passwordSalt);

        _passwordHash = passwordHash;
        _passwordSalt = passwordSalt;

        _logger.LogInformation("Seeding data...");

        var seededRoles = await SeedRolesAsync();
        var seededUsers = await SeedUsersAsync(seededRoles);
        var seededAnnouncements = await SeedAnnouncementsAsync(seededUsers);
        var seededRooms = await SeedRooms();
        var seededAppointmentTypes = await SeedAppointmentType();
        var seededAppointments = await SeedAppointments(seededRooms, seededAppointmentTypes, seededUsers);
        var seededAppointmentSchedules = await SeedAppointmentSchedulesAsync(seededAppointments);
        var seededEmails = await SeedEmails(seededUsers);
        var seededMalfunctionReports = await SeedMalfunctionReports(seededRooms, seededUsers);
        var seededPayments = await SeedPayments(seededUsers);
        var seededMembershipFees = await SeedMembershipFees(seededPayments);
        var seededNotifications = await SeedNotifications(seededUsers);
        var seededProfilePictures = await SeedProfilePictures(seededUsers);
        var seededTimes = await SeedTimes(seededAppointmentSchedules);

        _logger.LogInformation("Data seeded!");
    }

    private async Task<IEnumerable<Role>> SeedRolesAsync()
    {
        if (_context.Roles.Any())
        {
            _logger.LogInformation("Roles already seeded!");
            return await _context.Roles.ToListAsync();
        }

        _logger.LogInformation("Seeding roles...");

        IEnumerable<Role> roles =
        [
            new Role { Name = "Admin"},
            new Role { Name = "Osoblje"},
            new Role { Name = "Polaznik"},
        ];

        await _context.Roles.AddRangeAsync(roles);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Roles seeded!");

        return roles;
    }

    private async Task<IEnumerable<User>> SeedUsersAsync(IEnumerable<Role> roles)
    {
        if (_context.Users.Any())
        {
            _logger.LogInformation("Users already seeded!");
            return await _context.Users.ToListAsync();
        }

        _logger.LogInformation("Seeding users...");

        IEnumerable<User> users =
        [
            new User
            {
                Name = "Naida",
                Surname = "Kurtovic",
                Email = "naida.kurtovic@gmail.com",
                PhoneNumber = "061123456",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Admin").Id
            },
            new User
            {
                Name = "Semin",
                Surname = "Merzic",
                Email = "semin.merzic@gmail.com",
                PhoneNumber = "061546987",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Ivan",
                Surname = "Kovacevic",
                Email = "ivan.kovacevic@gmail.com",
                PhoneNumber = "061321654",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Emin",
                Surname = "Cevra",
                Email = "emin.cevra@gmail.com",
                PhoneNumber = "061546321",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Hrvoje",
                Surname = "Caculovic",
                Email = "hrvoje.caculovic@gmail.com",
                PhoneNumber = "063852147",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Ivan",
                Surname = "Zovko",
                Email = "ivan.zovko@gmail.com",
                PhoneNumber = "063456789",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Djeno",
                Surname = "Mujic",
                Email = "djeno.mujic@gmail.com",
                PhoneNumber = "061987654",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Ilija",
                Surname = "Soldo",
                Email = "ilija.soldo@gmail.com",
                PhoneNumber = "063654987",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Osoblje").Id
            },
            new User
            {
                Name = "Kenan",
                Surname = "Kajtazovic",
                Email = "kenan.kajtazovic@gmail.com",
                PhoneNumber = "061478523",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
            new User
            {
                Name = "Petar",
                Surname = "Zovko",
                Email = "petar.zovko@gmail.com",
                PhoneNumber = "063874512",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
            new User
            {
                Name = "Gojko",
                Surname = "Prusina",
                Email = "gojko.prusina@gmail.com",
                PhoneNumber = "063987456",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
            new User
            {
                Name = "Dora",
                Surname = "Sesar",
                Email = "dora.sesar@gmail.com",
                PhoneNumber = "063987456",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
            new User
            {
                Name = "Nika",
                Surname = "Banovic",
                Email = "nika.banovic@gmail.com",
                PhoneNumber = "063408456",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
            new User
            {
                Name = "Leo",
                Surname = "Cerkez",
                Email = "leo.cerkez@gmail.com",
                PhoneNumber = "063937456",
                PasswordHash = _passwordHash!,
                PasswordSalt = _passwordSalt!,
                IsRestricted = false,
                RoleId = roles.First(r => r.Name == "Polaznik").Id
            },
        ];

        await _context.Users.AddRangeAsync(users);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Users seeded!");

        return users;
    }

    private async Task<IEnumerable<Announcement>> SeedAnnouncementsAsync(IEnumerable<User> users)
    {
        if (_context.Announcements.Any())
        {
            _logger.LogInformation("Announcements already seeded!");
            return await _context.Announcements.ToListAsync();
        }

        _logger.LogInformation("Seeding announcements...");

        IEnumerable<Announcement> announcements =
        [
            new Announcement
            {
                Title = "Obavijest o neradnom danu",
                Content = "Muzicki Centar Pavarotti nece raditi u ponedeljak 25.11.2024. godine.",
                CreatedAt = new DateTime(2024, 11, 23, 13, 14, 32),
                IsDeleted = false,
                UserId = users.First(u => u.RoleId == 1).Id
            },
            new Announcement
            {
                Title = "Obavijest o neradnom danu",
                Content = "Muzicki Centar Pavarotti nece raditi u subotu 01.03.2025. godine.",
                CreatedAt = new DateTime(2025, 02, 27, 12, 31, 56),
                IsDeleted = false,
                UserId = users.First(u => u.RoleId == 1).Id
            },
            new Announcement
            {
                Title = "Obavijest o radnom vremenu studentske sluzbe",
                Content = "Radno vrijeme u subotu 22.03.2025. godine je od 08:00 do 12:00 sati.",
                CreatedAt = new DateTime(2025, 03, 20, 14, 46, 13),
                IsDeleted = false,
                UserId = users.First(u => u.RoleId == 1).Id
            },
            new Announcement
            {
                Title = "Prijave za jazz masterclass",
                Content = "Prijave za jazz masterclass su otvorene do 01.04.2025. godine.",
                CreatedAt = new DateTime(2025, 03, 23, 09, 52, 25),
                IsDeleted = false,
                UserId = users.First(u => u.RoleId == 1).Id
            },
            new Announcement
            {
                Title = "Programski koncert IV",
                Content = "Nastava se nece odrzati u cetvrtak 27.03.2025. godine zbog programskog koncerta.",
                CreatedAt = new DateTime(2025, 03, 25, 11, 10, 36),
                IsDeleted = false,
                UserId = users.First(u => u.RoleId == 1).Id
            },
        ];

        await _context.Announcements.AddRangeAsync(announcements);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Announcements seeded!");

        return announcements;
    }

    private async Task<IEnumerable<Room>> SeedRooms()
    {
        if (_context.Rooms.Any())
        {
            _logger.LogInformation("Rooms already seeded!");
            return await _context.Rooms.ToListAsync();
        }

        _logger.LogInformation("Seeding rooms...");

        IEnumerable<Room> rooms =
        [
            new Room { Name = "DK Studio", Type = "Studio", Color = "#4d96ff", IsActive = true },
            new Room { Name = "Studio B", Type = "Studio", Color = "#4ecdc4", IsActive = true },
            new Room { Name = "Studio 24", Type = "Studio", Color = "#a8e6cf", IsActive = true },
            new Room { Name = "Keys & Brass", Type = "Room", Color = "#c084fc", IsActive = true },
            new Room { Name = "Guitar Room 2", Type = "Room", Color = "#ff8e72", IsActive = true },
            new Room { Name = "Vocals", Type = "Room", Color = "#ff6b6b", IsActive = true },
            new Room { Name = "Guitar Room 1", Type = "Room", Color = "#ffc857", IsActive = true },

        ];

        await _context.Rooms.AddRangeAsync(rooms);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Rooms seeded!");

        return rooms;
    }

    private async Task<IEnumerable<AppointmentType>> SeedAppointmentType()
    {
        if (_context.AppointmentTypes.Any())
        {
            _logger.LogInformation("Appointment types already seeded!");
            return await _context.AppointmentTypes.ToListAsync();
        }

        _logger.LogInformation("Seeding appointment types...");

        IEnumerable<AppointmentType> appointmentTypes =
        [
            new AppointmentType { Name = "Bubnjevi" },
            new AppointmentType { Name = "Gitara" },
            new AppointmentType { Name = "Bass" },
            new AppointmentType { Name = "Klavijature" },
            new AppointmentType { Name = "Vokal" },
            new AppointmentType { Name = "Saksofon" },
            new AppointmentType { Name = "Audio produkcija" },
            new AppointmentType { Name = "Kreativna elektronska produkcija" },
            new AppointmentType { Name = "Vjezba" },
            new AppointmentType { Name = "Proba" },
            new AppointmentType { Name = "Tehnika" },
            new AppointmentType { Name = "Radionica" },
            new AppointmentType { Name = "Snimanje" },
            new AppointmentType { Name = "Muzicka teorija" },
            new AppointmentType { Name = "Perkusije" },
            new AppointmentType { Name = "Nadoknada" },
            new AppointmentType { Name = "Session 1" },
            new AppointmentType { Name = "Session 2" },
            new AppointmentType { Name = "Session 3" },
            new AppointmentType { Name = "Session 4" },
            new AppointmentType { Name = "Session 5" },
        ];

        await _context.AppointmentTypes.AddRangeAsync(appointmentTypes);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Appointment types seeded!");

        return appointmentTypes;
    }

    private async Task<IEnumerable<Appointment>> SeedAppointments(IEnumerable<Room> rooms, IEnumerable<AppointmentType> appointmentTypes, IEnumerable<User> users)
    {
        if (_context.Appointments.Any())
        {
            _logger.LogInformation("Appointments already seeded!");
            return await _context.Appointments.ToListAsync();
        }

        _logger.LogInformation("Seeding appointments...");


        var scheduleDates = new DateOnly[]
        {
            new(2025, 03, 24),
            new(2025, 03, 25),
            new(2025, 03, 26),
            new(2025, 03, 27),
            new(2025, 03, 28),
            new(2025, 03, 29),
            new(2025, 03, 20)
        };

        IEnumerable<Appointment> appointments =
        [   new Appointment
            {
                IsRepeating = true,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[0].DayOfWeek.ToString(),
                RepeatingDayOfWeek = scheduleDates[0].DayOfWeek,
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Gitara").Id,
                BookedByUserId = users.First(u => u.Name == "Ivan" && u.Surname == "Kovacevic").Id,
                Attendees = [.. users.Where(u => u.Name == "Kenan" && u.Surname == "Kajtazovic")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[1].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Guitar Room 1").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Nadoknada").Id,
                BookedByUserId = users.First(u => u.Name == "Ivan" && u.Surname == "Kovacevic").Id,
                Attendees = [.. users.Where(u => u.Name == "Kenan" && u.Surname == "Kajtazovic")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = true,
                DayOfOccurrance = scheduleDates[2].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Muzicka teorija").Id,
                BookedByUserId = users.First(u => u.Name == "Ivan" && u.Surname == "Kovacevic").Id,
                Attendees = [.. users.Where(u => u.Name == "Kenan" && u.Surname == "Kajtazovic")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[3].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Studio 24").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Vjezba").Id,
                BookedByUserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id
            },
            new Appointment
            {
                IsRepeating = true,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[4].DayOfWeek.ToString(),
                RepeatingDayOfWeek = scheduleDates[4].DayOfWeek,
                RoomId = rooms.First(r => r.Name == "Studio 24").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Gitara").Id,
                BookedByUserId = users.First(u => u.Name == "Emin" && u.Surname == "Cevra").Id,
                Attendees = [.. users.Where(u => u.Name == "Petar" && u.Surname == "Zovko")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[5].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Studio 24").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Nadoknada").Id,
                BookedByUserId = users.First(u => u.Name == "Emin" && u.Surname == "Cevra").Id,
                Attendees = [.. users.Where(u => u.Name == "Petar" && u.Surname == "Zovko")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = true,
                DayOfOccurrance = scheduleDates[6].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Muzicka teorija").Id,
                BookedByUserId = users.First(u => u.Name == "Emin" && u.Surname == "Cevra").Id,
                Attendees = [.. users.Where(u => u.Name == "Petar" && u.Surname == "Zovko")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[0].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Guitar Room 1").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Vjezba").Id,
                BookedByUserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id
            },
            new Appointment
            {
                IsRepeating = true,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[1].DayOfWeek.ToString(),
                RepeatingDayOfWeek = scheduleDates[1].DayOfWeek,
                RoomId = rooms.First(r => r.Name == "Vocals").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Vokal").Id,
                BookedByUserId = users.First(u => u.Name == "Ilija" && u.Surname == "Soldo").Id,
                Attendees = [.. users.Where(u => u.Name == "Gojko" && u.Surname == "Prusina")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[2].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Vocals").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Nadoknada").Id,
                BookedByUserId = users.First(u => u.Name == "Ilija" && u.Surname == "Soldo").Id,
                Attendees = [.. users.Where(u => u.Name == "Gojko" && u.Surname == "Prusina")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = true,
                DayOfOccurrance = scheduleDates[3].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Vocals").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Vokal").Id,
                BookedByUserId = users.First(u => u.Name == "Ilija" && u.Surname == "Soldo").Id,
                Attendees = [.. users.Where(u => u.Name == "Gojko" && u.Surname == "Prusina")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[4].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "DK Studio").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Vjezba").Id,
                BookedByUserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new Appointment
            {
                IsRepeating = true,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[5].DayOfWeek.ToString(),
                RepeatingDayOfWeek = scheduleDates[5].DayOfWeek,
                RoomId = rooms.First(r => r.Name == "Guitar Room 1").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Bass").Id,
                BookedByUserId = users.First(u => u.Name == "Hrvoje" && u.Surname == "Caculovic").Id,
                Attendees = [.. users.Where(u => u.Name == "Dora" && u.Surname == "Sesar")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[6].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Guitar Room 1").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Nadoknada").Id,
                BookedByUserId = users.First(u => u.Name == "Hrvoje" && u.Surname == "Caculovic").Id,
                Attendees = [.. users.Where(u => u.Name == "Dora" && u.Surname == "Sesar")]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[0].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "DK Studio").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Session 1").Id,
                BookedByUserId = users.First(u => u.Name == "Semin" && u.Surname == "Merzic").Id,
                Attendees = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[1].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Studio B").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Session 1").Id,
                BookedByUserId = users.First(u => u.Name == "Semin" && u.Surname == "Merzic").Id,
                Attendees = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },

            new Appointment
            {
                IsRepeating = false,
                IsCancelled = true,
                DayOfOccurrance = scheduleDates[0].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "DK Studio").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Proba").Id,
                BookedByUserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
                Attendees = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },
            new Appointment
            {
                IsRepeating = false,
                IsCancelled = false,
                DayOfOccurrance = scheduleDates[1].DayOfWeek.ToString(),
                RoomId = rooms.First(r => r.Name == "Studio B").Id,
                AppointmentTypeId = appointmentTypes.First(at => at.Name == "Proba").Id,
                BookedByUserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id,
                Attendees = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },
        ];

        await _context.Appointments.AddRangeAsync(appointments);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Appointments seeded!");

        return appointments;
    }

    private async Task<IEnumerable<AppointmentSchedule>> SeedAppointmentSchedulesAsync(IEnumerable<Appointment> appointments)
    {
        if (_context.AppointmentSchedules.Any())
        {
            _logger.LogInformation("Appointment schedules already seeded!");
            return await _context.AppointmentSchedules.ToListAsync();
        }

        _logger.LogInformation("Seeding appointment schedules...");

        var scheduleDates = new DateOnly[]
        {
            new(2025, 03, 24),
            new(2025, 03, 25),
            new(2025, 03, 26),
            new(2025, 03, 27),
            new(2025, 03, 28),
            new(2025, 03, 29),
            new(2025, 03, 20)
        };

        var appointmentSchedules = new List<AppointmentSchedule>();

        for (int i = 0; i < appointments.Count(); i++)
        {
            appointmentSchedules.Add
            (
                new AppointmentSchedule
                {
                    AppointmentId = appointments.ElementAt(i).Id,
                    Date = scheduleDates[i % scheduleDates.Length]
                }
            );
        }

        await _context.AppointmentSchedules.AddRangeAsync(appointmentSchedules);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Appointment schedules seeded!");

        return appointmentSchedules;
    }

    private async Task<IEnumerable<Email>> SeedEmails(IEnumerable<User> users)
    {
        if (_context.Emails.Any())
        {
            _logger.LogInformation("Emails already seeded!");
            return await _context.Emails.ToListAsync();
        }

        _logger.LogInformation("Seeding emails...");

        IEnumerable<Email> emails =
        [
            new Email
            {
                Subject = "Session band 4",
                Body = "Pozdrav Session band 4! Ulazimo u četvrti session krug koji broji 11 formacija. Vi ste Session band 4, tema je 70s i narednih mjesec dana ćete raditi u ovoj formaciji na zadatku kojeg ste dobili, te kreirati vlastitu autorsku pjesmu. Na tom putu i na probama pomoći će vam vaš band coach Semin Merzić. Dostavljamo zadatak i kontakte članova vašeg benda za vašu lakšu komunikaciju. Preporučujemo da se uvežete i na Facebook-u i napravite svoju grupu sa band coachem sa kojim ćete dogovarati bukiranje proba, obavještavanje o eventualnim izmjenama termina i sl.Vaš zadatak za ovaj krug je: Deep Purple - Misstreated. Sretno!",
                Users = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },
            new Email
            {
                Subject = "Session band 1",
                Body = "Pozdrav Session band 1! Ulazimo u četvrti session krug koji broji 10 formacija. Vi ste Session band 1, tema je 80s i narednih mjesec dana ćete raditi u ovoj formaciji na zadatku kojeg ste dobili, te kreirati vlastitu autorsku pjesmu. Na tom putu i na probama pomoći će vam vaš band coach Semin Merzić. Dostavljamo zadatak i kontakte članova vašeg benda za vašu lakšu komunikaciju. Preporučujemo da se uvežete i na Facebook-u i napravite svoju grupu sa band coachem sa kojim ćete dogovarati bukiranje proba, obavještavanje o eventualnim izmjenama termina i sl.Vaš zadatak za ovaj krug je: Bon Joiv - You Give Love A Bad Name. Sretno!",
                Users = [.. users.Where(u => sourceArray.Contains(u.Id))]
            },
            new Email
            {
                Subject = "Session band 1",
                Body = "Pozdrav Session band 1! Ulazimo u četvrti session krug koji broji 11 formacija. Vi ste Session band 1, tema je 90s i narednih mjesec dana ćete raditi u ovoj formaciji na zadatku kojeg ste dobili, te kreirati vlastitu autorsku pjesmu. Na tom putu i na probama pomoći će vam vaš band coach Semin Merzić. Dostavljamo zadatak i kontakte članova vašeg benda za vašu lakšu komunikaciju. Preporučujemo da se uvežete i na Facebook-u i napravite svoju grupu sa band coachem sa kojim ćete dogovarati bukiranje proba, obavještavanje o eventualnim izmjenama termina i sl.Vaš zadatak za ovaj krug je: Majke - Ja Sam Buducnost. Sretno!",
                Users = [.. users.Where(u => sourceArray.Contains(u.Id))]
            }
        ];

        await _context.Emails.AddRangeAsync(emails);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Emails seeded!");

        return emails;
    }

    private async Task<IEnumerable<MalfunctionReport>> SeedMalfunctionReports(IEnumerable<Room> rooms, IEnumerable<User> users)
    {
        if (_context.MalfunctionReports.Any())
        {
            _logger.LogInformation("Malfunction reports already seeded!");
            return await _context.MalfunctionReports.ToListAsync();
        }

        _logger.LogInformation("Seeding malfunction reports...");

        IEnumerable<MalfunctionReport> malfunctionReports =
        [
            new MalfunctionReport
            {
                Description = "Ne radi klavijatura u Studiju 24.",
                Date = new DateTime(2025, 03, 24, 10, 15, 00),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "Studio 24").Id,
                ReportedByUserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi mikrofon u DK Studiju.",
                Date = new DateTime(2025, 03, 25, 11, 30, 00),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "DK Studio").Id,
                ReportedByUserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi gitara u Studiju B.",
                Date = new DateTime(2025, 03, 26, 12, 45, 00),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "Studio B").Id,
                ReportedByUserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },

            new MalfunctionReport
            {
                Description = "Svi kablovi za instrumente su neispravni u Guitar Room 2",
                Date = new DateTime(2025, 03, 27, 14, 00, 00),
                IsArchived = true,
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                ReportedByUserId = users.First(u => u.Name == "Ivan" && u.Surname == "Kovacevic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi gitarsko pojačalo u Studiju B.",
                Date = new DateTime(2025, 03, 28, 15, 15, 00),
                IsArchived = true,
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                ReportedByUserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi mikseta u Studiju B.",
                Date = new DateTime(2025, 03, 29, 16, 30, 00),
                IsArchived = true,
                RoomId = rooms.First(r => r.Name == "Studio B").Id,
                ReportedByUserId = users.First(u => u.Name == "Semin" && u.Surname == "Merzic").Id,
            },
        ];

        await _context.MalfunctionReports.AddRangeAsync(malfunctionReports);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Malfunction reports seeded!");

        return malfunctionReports;
    }

    private async Task<IEnumerable<Payment>> SeedPayments(IEnumerable<User> users)
    {
        if (_context.Payments.Any())
        {
            _logger.LogInformation("Payments already seeded!");
            return await _context.Payments.ToListAsync();
        }

        _logger.LogInformation("Seeding payments...");

        IEnumerable<Payment> payments =
        [
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 24, 10, 15, 00),
                Amount = 50.00m,
                Status = PaymentStatus.Zavrseno,
                PaymentMethod = PaymentMethod.PayPal,
                TransactionId = "1",
                UserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id
            },
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 25, 11, 30, 00),
                Amount = 50.00m,
                Status = PaymentStatus.NaCekanju,
                PaymentMethod = PaymentMethod.KreditnaKartica,
                TransactionId = "2",
                UserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 26, 12, 45, 00),
                Amount = 50.00m,
                Status = PaymentStatus.Neuspjesno,
                PaymentMethod = PaymentMethod.BankovniTransfer,
                TransactionId = "3",
                UserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 27, 14, 00, 00),
                Amount = 50.00m,
                Status = PaymentStatus.Zavrseno,
                PaymentMethod = PaymentMethod.PayPal,
                TransactionId = "4",
                UserId = users.First(u => u.Name == "Dora" && u.Surname == "Sesar").Id,
            },
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 28, 15, 15, 00),
                Amount = 50.00m,
                Status = PaymentStatus.Neuspjesno,
                PaymentMethod = PaymentMethod.KreditnaKartica,
                TransactionId = "5",
                UserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new Payment
            {
                PaidAt = new DateTime(2025, 03, 29, 16, 30, 00),
                Amount = 50.00m,
                Status = PaymentStatus.NaCekanju,
                PaymentMethod = PaymentMethod.BankovniTransfer,
                TransactionId = "6",
                UserId = users.First(u => u.Name == "Leo" && u.Surname == "Cerkez").Id,
            },
        ];

        await _context.Payments.AddRangeAsync(payments);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Payments seeded!");

        return payments;
    }

    private async Task<IEnumerable<MembershipFee>> SeedMembershipFees(IEnumerable<Payment> payments)
    {
        if (_context.MembershipFees.Any())
        {
            _logger.LogInformation("Membership fees already seeded!");
            return await _context.MembershipFees.ToListAsync();
        }

        _logger.LogInformation("Seeding membership fees...");

        IEnumerable<MembershipFee> membershipFees =
        [
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 9).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 1
            },
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 10).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 2
            },
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 11).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 3
            },
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 12).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 4
            },
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 13).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 5
            },
            new MembershipFee
            {
                CreatedAt = payments.Where(p=> p.UserId == 14).First().PaidAt,
                MembershipType = MembershipType.Mjesecna,
                PaymentId = 6
            },
        ];

        await _context.MembershipFees.AddRangeAsync(membershipFees);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Membership fees seeded!");

        return membershipFees;
    }

    private async Task<IEnumerable<Notification>> SeedNotifications(IEnumerable<User> users)
    {
        if (_context.Notifications.Any())
        {
            _logger.LogInformation("Notifications already seeded!");
            return await _context.Notifications.ToListAsync();
        }

        _logger.LogInformation("Seeding notifications...");

        IEnumerable<Notification> notifications =
        [
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Uspjesno,
                Date = new DateTime(2025, 03, 24, 10, 20, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu na cekanju.",
                Type = NotificationType.Informacija,
                Date = new DateTime(2025, 03, 25, 11, 35, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu neuspijesna.",
                Type = NotificationType.Uspjesno,
                Date = new DateTime(2025, 03, 27, 12, 50, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Uspjesno,
                Date = new DateTime(2025, 03, 24, 14, 05, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Dora" && u.Surname == "Sesar").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Informacija,
                Date = new DateTime(2025, 03, 24, 15, 20, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu na cekanju.",
                Type = NotificationType.Informacija,
                Date = new DateTime(2025, 03, 24, 16, 35, 00),
                IsRead = false,
                UserId = users.First(u => u.Name == "Leo" && u.Surname == "Cerkez").Id,
            },
        ];

        await _context.Notifications.AddRangeAsync(notifications);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Notifications seeded!");

        return notifications;
    }
    private async Task<IEnumerable<ProfilePicture>> SeedProfilePictures(IEnumerable<User> users)
    {
        if (_context.ProfilePictures.Any())
        {
            _logger.LogInformation("Profile pictures already seeded!");
            return await _context.ProfilePictures.ToListAsync();
        }

        _logger.LogInformation("Seeding profile pictures...");

        var profilePictures = new List<ProfilePicture>();

        var minimalPngData = new byte[]
        {
            0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
            0x00, 0x00, 0x00, 0x0D,
            0x49, 0x48, 0x44, 0x52,
            0x00, 0x00, 0x00, 0x01,
            0x00, 0x00, 0x00, 0x01,
            0x08, 0x06, 0x00, 0x00, 0x00,
            0x1F, 0x15, 0xC4, 0x89,
            0x00, 0x00, 0x00, 0x0A,
            0x49, 0x44, 0x41, 0x54,
            0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01,
            0x0D, 0x0A, 0x2D, 0xB4,
            0x00, 0x00, 0x00, 0x00,
            0x49, 0x45, 0x4E, 0x44,
            0xAE, 0x42, 0x60, 0x82
        };

        foreach (var u in users)
        {
            profilePictures.Add
            (
                new ProfilePicture
                {
                    Data = minimalPngData,
                    FileName = $"{u.Name}_{u.Surname}.png",
                    FileType = "image/png",
                    UserId = u.Id
                }
            );
        }

        await _context.ProfilePictures.AddRangeAsync(profilePictures);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Profile pictures seeded!");

        return profilePictures;
    }
    private async Task<IEnumerable<TimeSlot>> SeedTimes(IEnumerable<AppointmentSchedule> appointmentSchedules)
    {
        if (_context.Times.Any())
        {
            _logger.LogInformation("Time slots already seeded!");
            return await _context.Times.ToListAsync();
        }

        _logger.LogInformation("Seeding times...");


        var timeSlots = new[]
        {
            new { From = new TimeSpan(08, 00, 00), To = new TimeSpan(10, 00, 00) },
            new { From = new TimeSpan(10, 00, 00), To = new TimeSpan(12, 00, 00) },
            new { From = new TimeSpan(12, 00, 00), To = new TimeSpan(14, 00, 00) },
            new { From = new TimeSpan(14, 00, 00), To = new TimeSpan(16, 00, 00) },
            new { From = new TimeSpan(16, 00, 00), To = new TimeSpan(18, 00, 00) },
            new { From = new TimeSpan(18, 00, 00), To = new TimeSpan(20, 00, 00) },
            new { From = new TimeSpan(20, 00, 00), To = new TimeSpan(22, 00, 00) }
        };

        var times = new List<TimeSlot>();
        var appointmentSchedulesList = appointmentSchedules.ToList();

        for (int i = 0; i < appointmentSchedulesList.Count; i++)
        {
            var timeSlot = timeSlots[i % timeSlots.Length];
            times.Add(new TimeSlot
            {
                TimeFrom = timeSlot.From,
                TimeTo = timeSlot.To,
                AppointmentScheduleId = appointmentSchedulesList[i].Id
            });
        }

        await _context.Times.AddRangeAsync(times);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Time slots seeded!");

        return times;
    }
}
