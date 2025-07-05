using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Extensions;

public static class DataSeederServiceCollectionExtensions
{
    public static IServiceCollection AddDataSeeder(this IServiceCollection services)
    {
        services.AddTransient<DataSeeder>();
        return services;
    }
}
