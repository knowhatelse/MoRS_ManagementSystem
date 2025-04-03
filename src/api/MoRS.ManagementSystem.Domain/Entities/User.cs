namespace MoRS.ManagementSystem.Domain.Entities;

public class User
{
    public int Id { get; set; }

    public required string Name { get; set; }
    public required string Surname { get; set; }
    public required string Email { get; set; }
    public required string PhoneNumber { get; set; }
    public required string PasswordHash { get; set; }
    public required string PasswordSalt { get; set; }
    public bool IsRestricted { get; set; }
    public ProfilePicture? ProfilePicture { get; set; }

    public int RoleId { get; set; }
    public Role Role { get; set; } = null!;

    public ICollection<Announcement> Announcements { get; set; } = [];
    public ICollection<Appointment> CreatedAppointments { get; set; } = [];
    public ICollection<MalfunctionReport> MalfunctionReports { get; set; } = [];
    public ICollection<Notification> Notifications { get; set; } = [];
    public ICollection<Payment> Payments { get; set; } = [];
    public List<Appointment> AttendingAppointments { get; set; } = [];
    public List<Email> Emails { get; set; } = [];

}
