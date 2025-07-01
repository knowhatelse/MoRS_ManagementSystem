using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Infrastructure.Services;

namespace MoRS.ManagementSystem.Infrastructure.Extensions
{
    public static class UserManagementServiceCollectionExtensions
    {
        public static IServiceCollection AddUserManagementService(this IServiceCollection services)
        {
            services.AddScoped<UserManagementService>();
            return services;
        }
    }
}
