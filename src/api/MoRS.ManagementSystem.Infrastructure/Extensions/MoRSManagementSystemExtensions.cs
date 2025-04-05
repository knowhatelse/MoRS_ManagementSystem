using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Infrastructure.Interfaces.Repositories;
using MoRS.ManagementSystem.Infrastructure.Repositories;

namespace MoRS.ManagementSystem.Infrastructure.Extensions;

public static class RepositoryServiceCollectionExtensions
{
    public static IServiceCollection AddRepositoryServices(this IServiceCollection services)
    {
        services.AddScoped<IAnnouncementRepository, AnnouncementRepository>();
        services.AddScoped<IAppointmentRepository, AppointmentRepository>();
        services.AddScoped<IAppointmentScheduleRepository, AppointmentScheduleRepository>();
        services.AddScoped<IAppointmentTypeRepository, AppointmentTypeRepository>();
        services.AddScoped<IEmailRepository, EmailRepository>();
        services.AddScoped<IMalfunctionReportRepository, MalfunctionReportRepository>();
        services.AddScoped<IMembershipFeeRepository, MembershipFeeRepository>();
        services.AddScoped<INotificationRepository, NotificationRepository>();
        services.AddScoped<IPaymentRepository, PaymentRepository>();
        services.AddScoped<IProfilePictureRepository, ProfilePictureRepository>();
        services.AddScoped<IRoleRepository, RoleRepository>();
        services.AddScoped<IRoomRepository, RoomRepository>();
        services.AddScoped<ITimeSlotRepository, TimeSlotRepository>();
        services.AddScoped<IUserRepository, UserRepository>();

        return services;
    }
}
