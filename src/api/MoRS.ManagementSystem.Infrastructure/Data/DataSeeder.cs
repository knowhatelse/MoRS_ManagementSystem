using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MoRS.ManagementSystem.Application.Utils;
using MoRS.ManagementSystem.Domain.Entities;
using MoRS.ManagementSystem.Domain.Enums;
using MoRS.ManagementSystem.Infrastructure.Identity;

namespace MoRS.ManagementSystem.Infrastructure.Data;

public class DataSeeder
{
    private readonly MoRSManagementSystemDbContext _context;
    private readonly ILogger<DataSeeder> _logger;
    private readonly UserManager<ApplicationUser> _userManager;

    private static readonly int[] sourceArray = [9, 10, 11, 12, 13, 14];

    public DataSeeder(MoRSManagementSystemDbContext context, ILogger<DataSeeder> logger, UserManager<ApplicationUser> userManager)
    {
        _context = context;
        _logger = logger;
        _userManager = userManager;
    }

    public async Task SeedData()
    {
        _logger.LogInformation("Seeding data...");

        var seededDomainRoles = await SeedDomainRolesAsync();
        var seededRoles = await SeedRolesAsync();
        var seededUsers = await SeedUsersAsync(seededRoles, seededDomainRoles);
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

    private async Task<IEnumerable<Role>> SeedDomainRolesAsync()
    {
        var requiredRoles = new[]
        {
            new Role { Id = 1, Name = "Admin" },
            new Role { Id = 2, Name = "Osoblje" },
            new Role { Id = 3, Name = "Polaznik" }
        };

        var existingRoles = await _context.Set<Role>().ToListAsync();
        foreach (var reqRole in requiredRoles)
        {
            var dbRole = existingRoles.FirstOrDefault(r => r.Id == reqRole.Id);
            if (dbRole != null)
            {
                if (dbRole.Name != reqRole.Name)
                {
                    dbRole.Name = reqRole.Name;
                }
            }
            else
            {
                var wrongIdRole = existingRoles.FirstOrDefault(r => r.Name == reqRole.Name && r.Id != reqRole.Id);
                if (wrongIdRole != null)
                {
                    _context.Set<Role>().Remove(wrongIdRole);
                    await _context.SaveChangesAsync();
                }
                await _context.Database.ExecuteSqlRawAsync(
                    "SET IDENTITY_INSERT [Role] ON; INSERT INTO [Role] ([Id], [Name]) VALUES ({0}, {1}); SET IDENTITY_INSERT [Role] OFF;",
                    reqRole.Id, reqRole.Name
                );
            }
        }
        await _context.SaveChangesAsync();
        return await _context.Set<Role>().ToListAsync();
    }

    private async Task<IEnumerable<User>> SeedUsersAsync(IEnumerable<ApplicationRole> identityRoles, IEnumerable<Role> domainRoles)
    {
        if (_context.Set<User>().Any())
        {
            _logger.LogInformation("Users already seeded!");
            return await _context.Set<User>().ToListAsync();
        }

        _logger.LogInformation("Seeding users...");

        var userList = new List<User>();
        var usersToSeed = new[]
        {
            new { Name = "Naida", Surname = "Kurtovic", Email = "naida.kurtovic@gmail.com", PhoneNumber = "061123456", RoleName = "Admin" },
            new { Name = "Semin", Surname = "Merzic", Email = "semin.merzic@gmail.com", PhoneNumber = "061546987", RoleName = "Osoblje" },
            new { Name = "Ivan", Surname = "Kovacevic", Email = "ivan.kovacevic@gmail.com", PhoneNumber = "061321654", RoleName = "Osoblje" },
            new { Name = "Emin", Surname = "Cevra", Email = "emin.cevra@gmail.com", PhoneNumber = "061546321", RoleName = "Osoblje" },
            new { Name = "Hrvoje", Surname = "Caculovic", Email = "hrvoje.caculovic@gmail.com", PhoneNumber = "063852147", RoleName = "Osoblje" },
            new { Name = "Ivan", Surname = "Zovko", Email = "ivan.zovko@gmail.com", PhoneNumber = "063456789", RoleName = "Osoblje" },
            new { Name = "Djeno", Surname = "Mujic", Email = "djeno.mujic@gmail.com", PhoneNumber = "061987654", RoleName = "Osoblje" },
            new { Name = "Ilija", Surname = "Soldo", Email = "ilija.soldo@gmail.com", PhoneNumber = "063654987", RoleName = "Osoblje" },
            new { Name = "Kenan", Surname = "Kajtazovic", Email = "kenan.kajtazovic@gmail.com", PhoneNumber = "061478523", RoleName = "Polaznik" },
            new { Name = "Petar", Surname = "Zovko", Email = "petar.zovko@gmail.com", PhoneNumber = "063874512", RoleName = "Polaznik" },
            new { Name = "Gojko", Surname = "Prusina", Email = "gojko.prusina@gmail.com", PhoneNumber = "063987456", RoleName = "Polaznik" },
            new { Name = "Dora", Surname = "Sesar", Email = "dora.sesar@gmail.com", PhoneNumber = "063987456", RoleName = "Polaznik" },
            new { Name = "Nika", Surname = "Banovic", Email = "nika.banovic@gmail.com", PhoneNumber = "063408456", RoleName = "Polaznik" },
            new { Name = "Leo", Surname = "Cerkez", Email = "leo.cerkez@gmail.com", PhoneNumber = "063937456", RoleName = "Polaznik" },
            new { Name = "Denis", Surname = "Music", Email = "denis.music@edu.fit.ba", PhoneNumber = "061111111", RoleName = "Polaznik" },
            new { Name = "Elmir", Surname = "Babovic", Email = "elmir.babovic@edu.fit.ba", PhoneNumber = "061222222", RoleName = "Polaznik" },
            new { Name = "Amel", Surname = "Music", Email = "amel.music@edu.fit.ba", PhoneNumber = "061333333", RoleName = "Polaznik" },
            new { Name = "Adil", Surname = "Joldic", Email = "adil.joldic@edu.fit.ba", PhoneNumber = "061444444", RoleName = "Polaznik" },
            new { Name = "Elda", Surname = "Sultic", Email = "elda.sultic@edu.fit.ba", PhoneNumber = "061555555", RoleName = "Polaznik" },
        };

        foreach (var u in usersToSeed)
        {
            var identityRole = identityRoles.FirstOrDefault(r => (r.Name?.ToLower() ?? "") == u.RoleName.ToLower());
            var domainRole = domainRoles.FirstOrDefault(r => (r.Name?.ToLower() ?? "") == u.RoleName.ToLower());
            if (identityRole == null || domainRole == null)
            {
                continue;
            }
            var roleId = domainRole.Id;
            var dbRoleName = identityRole.Name ?? string.Empty;
            var password = "Test123$";
            var identityUser = new ApplicationUser
            {
                UserName = u.Email,
                Email = u.Email,
                Name = u.Name,
                Surname = u.Surname,
                PhoneNumber = u.PhoneNumber
            };
            var result = await _userManager.CreateAsync(identityUser, password);
            if (result.Succeeded)
            {
                var domainUser = new User
                {
                    Id = identityUser.Id,
                    Name = u.Name,
                    Surname = u.Surname,
                    Email = u.Email,
                    PhoneNumber = u.PhoneNumber,
                    RoleId = roleId,
                    ProfilePicture = null,
                    IsRestricted = false,
                };
                userList.Add(domainUser);
                _context.Set<User>().Add(domainUser);
            }
        }
        await _context.SaveChangesAsync();
        return userList;
    }

    private async Task<IEnumerable<ApplicationRole>> SeedRolesAsync()
    {
        var requiredRoles = new[] { "Admin", "Osoblje", "Polaznik" };
        var existingRoles = await _context.Roles.ToListAsync();
        var rolesToAdd = requiredRoles.Except(existingRoles.Select(r => r.Name)).ToList();
        if (rolesToAdd.Any())
        {
            foreach (var roleName in rolesToAdd)
            {
                await _context.Roles.AddAsync(new ApplicationRole { Name = roleName ?? string.Empty, NormalizedName = (roleName ?? string.Empty).ToUpperInvariant() });
            }
            await _context.SaveChangesAsync();
        }

        foreach (var role in _context.Roles)
        {
            var expectedNorm = (role.Name?.ToUpperInvariant()) ?? string.Empty;
            if (role.NormalizedName != expectedNorm)
            {
                role.NormalizedName = expectedNorm;
            }
        }
        await _context.SaveChangesAsync();
        return await _context.Roles.ToListAsync();
    }

    private async Task<IEnumerable<Announcement>> SeedAnnouncementsAsync(IEnumerable<User> users)
    {
        if (_context.Announcements.Any())
        {
            _logger.LogInformation("Announcements already seeded!");
            return await _context.Announcements.ToListAsync();
        }

        _logger.LogInformation("Seeding announcements...");

        var adminUser = users.FirstOrDefault(u => u.RoleId == 1);
        if (adminUser == null)
            throw new InvalidOperationException("No admin user found for announcement seeding.");

        var now = DateTime.Now;
        var baseDate = now.AddDays(-30); 

        IEnumerable<Announcement> announcements =
        [
            new Announcement
            {
                Title = "Obavijest o neradnom danu",
                Content = "Muzicki Centar Pavarotti nece raditi u ponedeljak.",
                CreatedAt = baseDate.AddDays(2),
                IsDeleted = false,
                UserId = adminUser.Id
            },
            new Announcement
            {
                Title = "Obavijest o neradnom danu",
                Content = "Muzicki Centar Pavarotti nece raditi u subotu.",
                CreatedAt = baseDate.AddDays(5),
                IsDeleted = false,
                UserId = adminUser.Id
            },
            new Announcement
            {
                Title = "Obavijest o radnom vremenu studentske sluzbe",
                Content = "Radno vrijeme u subotu je od 08:00 do 12:00 sati.",
                CreatedAt = baseDate.AddDays(8),
                IsDeleted = false,
                UserId = adminUser.Id
            },
            new Announcement
            {
                Title = "Prijave za jazz masterclass",
                Content = "Prijave za jazz masterclass su otvorene.",
                CreatedAt = baseDate.AddDays(12),
                IsDeleted = false,
                UserId = adminUser.Id
            },
            new Announcement
            {
                Title = "Programski koncert IV",
                Content = "Nastava se nece odrzati u cetvrtak zbog programskog koncerta.",
                CreatedAt = baseDate.AddDays(15),
                IsDeleted = false,
                UserId = adminUser.Id
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

        var today = DateOnly.FromDateTime(DateTime.Now);
        var daysFromMonday = (int)today.DayOfWeek - 1;
        if (daysFromMonday < 0) daysFromMonday = 6;

        var mondayOfCurrentWeek = today.AddDays(-daysFromMonday);

        var scheduleDates = new DateOnly[]
        {
            mondayOfCurrentWeek,
            mondayOfCurrentWeek.AddDays(1),
            mondayOfCurrentWeek.AddDays(2),
            mondayOfCurrentWeek.AddDays(3),
            mondayOfCurrentWeek.AddDays(4),
            mondayOfCurrentWeek.AddDays(5),
            mondayOfCurrentWeek.AddDays(6)
        };

        _logger.LogInformation($"Seeding appointments for week of {mondayOfCurrentWeek} to {mondayOfCurrentWeek.AddDays(6)}");

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


        var today = DateOnly.FromDateTime(DateTime.Now);
        var daysFromMonday = (int)today.DayOfWeek - 1; 
        if (daysFromMonday < 0) daysFromMonday = 6; 

        var mondayOfCurrentWeek = today.AddDays(-daysFromMonday);

        var scheduleDates = new DateOnly[]
        {
            mondayOfCurrentWeek,           
            mondayOfCurrentWeek.AddDays(1), 
            mondayOfCurrentWeek.AddDays(2), 
            mondayOfCurrentWeek.AddDays(3), 
            mondayOfCurrentWeek.AddDays(4), 
            mondayOfCurrentWeek.AddDays(5), 
            mondayOfCurrentWeek.AddDays(6)  
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

        var now = DateTime.Now;
        var baseDate = now.AddDays(-7);

        IEnumerable<MalfunctionReport> malfunctionReports =
        [
            new MalfunctionReport
            {
                Description = "Ne radi klavijatura u Studiju 24.",
                Date = baseDate.AddDays(1),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "Studio 24").Id,
                ReportedByUserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi mikrofon u DK Studiju.",
                Date = baseDate.AddDays(2),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "DK Studio").Id,
                ReportedByUserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi gitara u Studiju B.",
                Date = baseDate.AddDays(3),
                IsArchived = false,
                RoomId = rooms.First(r => r.Name == "Studio B").Id,
                ReportedByUserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },

            new MalfunctionReport
            {
                Description = "Svi kablovi za instrumente su neispravni u Guitar Room 2",
                Date = baseDate.AddDays(4),
                IsArchived = true,
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                ReportedByUserId = users.First(u => u.Name == "Ivan" && u.Surname == "Kovacevic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi gitarsko pojačalo u Studiju B.",
                Date = baseDate.AddDays(5),
                IsArchived = true,
                RoomId = rooms.First(r => r.Name == "Guitar Room 2").Id,
                ReportedByUserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id,
            },
            new MalfunctionReport
            {
                Description = "Ne radi mikseta u Studiju B.",
                Date = baseDate.AddDays(6),
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

        var now = DateTime.Now;
        var baseDate = now.AddDays(-5);

        IEnumerable<Payment> payments =
        [
            new Payment
            {
                PaidAt = baseDate.AddDays(1),
                Amount = 50.00m,
                Status = PaymentStatus.Zavrseno,
                PaymentMethod = PaymentMethod.PayPal,
                TransactionId = "1",
                UserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id
            },
            new Payment
            {
                PaidAt = baseDate.AddDays(2),
                Amount = 50.00m,
                Status = PaymentStatus.NaCekanju,
                PaymentMethod = PaymentMethod.KreditnaKartica,
                TransactionId = "2",
                UserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },
            new Payment
            {
                PaidAt = baseDate.AddDays(3),
                Amount = 50.00m,
                Status = PaymentStatus.Neuspjesno,
                PaymentMethod = PaymentMethod.BankovniTransfer,
                TransactionId = "3",
                UserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new Payment
            {
                PaidAt = baseDate.AddDays(4),
                Amount = 50.00m,
                Status = PaymentStatus.Zavrseno,
                PaymentMethod = PaymentMethod.PayPal,
                TransactionId = "4",
                UserId = users.First(u => u.Name == "Dora" && u.Surname == "Sesar").Id,
            },
            new Payment
            {
                PaidAt = baseDate.AddDays(5),
                Amount = 50.00m,
                Status = PaymentStatus.Neuspjesno,
                PaymentMethod = PaymentMethod.KreditnaKartica,
                TransactionId = "5",
                UserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new Payment
            {
                PaidAt = now,
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

        var now = DateTime.Now;
        var baseDate = now.AddDays(-3); 

        IEnumerable<Notification> notifications =
        [
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Uspjesno,
                Date = baseDate.AddDays(1),
                IsRead = false,
                UserId = users.First(u => u.Name == "Kenan" && u.Surname == "Kajtazovic").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu na cekanju.",
                Type = NotificationType.Informacija,
                Date = baseDate.AddDays(2),
                IsRead = false,
                UserId = users.First(u => u.Name == "Petar" && u.Surname == "Zovko").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu neuspijesna.",
                Type = NotificationType.Uspjesno,
                Date = baseDate.AddDays(3),
                IsRead = false,
                UserId = users.First(u => u.Name == "Gojko" && u.Surname == "Prusina").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Uspjesno,
                Date = now.AddHours(-12),
                IsRead = false,
                UserId = users.First(u => u.Name == "Dora" && u.Surname == "Sesar").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu uspjesno izvrsena.",
                Type = NotificationType.Informacija,
                Date = now.AddHours(-6),
                IsRead = false,
                UserId = users.First(u => u.Name == "Nika" && u.Surname == "Banovic").Id,
            },
            new Notification
            {
                Title = "Obavijest o placanju",
                Message = "Obavještavamo vas da je uplata za clanarinu na cekanju.",
                Type = NotificationType.Informacija,
                Date = now.AddHours(-2),
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
      
        var profilePicturesPath = Path.Combine(Directory.GetCurrentDirectory(), "Images");

        _logger.LogInformation($"Looking for profile pictures in: {profilePicturesPath}");
       
        var profilePicturesExist = Directory.Exists(profilePicturesPath);
        if (!profilePicturesExist)
        {
            _logger.LogWarning($"Images directory not found at {profilePicturesPath}. Using default images.");
        }

        foreach (var user in users)
        {
            byte[] imageData = minimalPngData;
            string fileName = $"{user.Name}_{user.Surname}.png";
            string contentType = "image/png";
           
            if (profilePicturesExist)
            {
                var loadedImage = await TryLoadUserProfilePicture(profilePicturesPath, user.Name, user.Surname);
                if (loadedImage.HasValue)
                {
                    imageData = loadedImage.Value.Data;
                    fileName = loadedImage.Value.FileName;
                    contentType = loadedImage.Value.ContentType;
                    _logger.LogInformation($"Loaded profile picture for {user.Name} {user.Surname}: {fileName}");
                }
                else
                {
                    _logger.LogInformation($"No profile picture found for {user.Name} {user.Surname}. Using default image.");
                }
            }

            profilePictures.Add(new ProfilePicture
            {
                Data = imageData,
                FileName = fileName,
                FileType = contentType,
                UserId = user.Id
            });
        }

        await _context.ProfilePictures.AddRangeAsync(profilePictures);
        await _context.SaveChangesAsync();

        _logger.LogInformation($"Profile pictures seeded! {profilePictures.Count} pictures added.");

        return profilePictures;
    }

    private async Task<(byte[] Data, string FileName, string ContentType)?> TryLoadUserProfilePicture(string profilePicturesPath, string name, string surname)
    {
        try
        {
            var extensions = new[] { ".png", ".jpg", ".jpeg", ".gif", ".bmp" };
            var userNamePattern = $"{name}_{surname}";

            foreach (var extension in extensions)
            {
                var filePath = Path.Combine(profilePicturesPath, $"{userNamePattern}{extension}");
                if (File.Exists(filePath))
                {
                    var data = await File.ReadAllBytesAsync(filePath);
                    var contentType = GetContentType(extension);
                    var fileName = Path.GetFileName(filePath);

                    _logger.LogInformation($"Found profile picture: {filePath} ({data.Length} bytes)");
                    return (data, fileName, contentType);
                }
            }

            return null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Error loading profile picture for {name} {surname}");
            return null;
        }
    }

    private static string GetContentType(string extension)
    {
        return extension.ToLower() switch
        {
            ".png" => "image/png",
            ".jpg" => "image/jpeg",
            ".jpeg" => "image/jpeg",
            ".gif" => "image/gif",
            ".bmp" => "image/bmp",
            _ => "application/octet-stream"
        };
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
