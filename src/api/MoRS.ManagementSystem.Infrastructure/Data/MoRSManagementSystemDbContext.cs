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
    public DbSet<TimeSlot> Times { get; set; }
    public DbSet<User> Users { get; set; }


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Appointment>()
            .HasOne(a => a.BookedByUser)
            .WithMany(u => u.CreatedAppointments)
            .HasForeignKey(a => a.BookedByUserId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<User>()
            .HasMany(u => u.AttendingAppointments)
            .WithMany(a => a.Attendees)
            .UsingEntity(j => j.ToTable("UserAppointments"));

        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        modelBuilder.Entity<Email>()
            .HasMany(e => e.Users)
            .WithMany(u => u.Emails)
            .UsingEntity(j => j.ToTable("UserEmails"));

        modelBuilder.Entity<Notification>()
           .Property(n => n.Type)
           .HasConversion<string>();

        modelBuilder.Entity<Payment>(entity =>
        {
            entity.Property(e => e.Amount).HasPrecision(18, 4);
            entity.Property(p => p.PaymentMethod).HasConversion<string>();
            entity.Property(p => p.Status).HasConversion<string>();
        });

        modelBuilder.Entity<MembershipFee>()
            .Property(mf => mf.MembershipType)
            .HasConversion<string>();

    }
}
