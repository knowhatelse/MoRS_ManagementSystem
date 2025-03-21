using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Infrastructure.Data;

public class MoRSManagementSystemDbContext(DbContextOptions<MoRSManagementSystemDbContext> options) : DbContext(options)
{
    public DbSet<Announcement> Announcements { get; set; }
    public DbSet<Appointment> Appointments { get; set; }
    public DbSet<AppointmentSchedule> AppointmentSchedules { get; set; }
    public DbSet<AppointmentType> AppointmentTypes { get; set; }
    public DbSet<Email> Emails { get; set; }
    public DbSet<MalfunctionReport> MalfunctionReports { get; set; }
    public DbSet<MembershipFee> MembershipFees { get; set; }
    public DbSet<Notification> Notifications { get; set; }
    public DbSet<Payment> Payments { get; set; }
    public DbSet<ProfilePicture> ProfilePictures { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<Room> Rooms { get; set; }
    public DbSet<Time> Times { get; set; }
    public DbSet<User> Users { get; set; }
    
}
