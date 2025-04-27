using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Application.Interfaces.Services;
using MoRS.ManagementSystem.Application.Services;

namespace MoRS.ManagementSystem.Application.Extensions;

public static class ApplicationServiceCollectionExtensions
{
    public static IServiceCollection AddServices(this IServiceCollection services)
    {
        services.AddScoped<IAnnouncementService, AnnouncementService>();
        services.AddScoped<IAppointmentService, AppointmentService>();
        services.AddScoped<IEmailService, EmailService>();
        services.AddScoped<IMalfunctionReportService, MalfunctionReportService>();
        services.AddScoped<IProfilePictureService, ProfilePictureService>();
        services.AddScoped<IRoomService, RoomService>();
        services.AddScoped<IUserService, UserService>();
        services.AddScoped<INotificationService, NotificationService>();

        return services;
    }
}
