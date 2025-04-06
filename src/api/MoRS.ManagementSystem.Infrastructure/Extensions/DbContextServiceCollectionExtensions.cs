using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Extensions;

public static class DbContextServiceCollectionExtensions
{
    public static IServiceCollection AddMoRSManagementSystemDbContext(this IServiceCollection services, string connectionString)
    {
        services.AddDbContext<MoRSManagementSystemDbContext>(options =>
        {
            options.UseSqlServer(connectionString);
        });
        return services;
    }
}
