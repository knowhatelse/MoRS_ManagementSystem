using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using MoRS.ManagementSystem.Infrastructure.Data;

namespace MoRS.ManagementSystem.Infrastructure.Extensions
{
    public static class DataSeederExtensions
    {
        public static async Task SeedDatabaseAsync(this IApplicationBuilder app)
        {
            using var scope = app.ApplicationServices.CreateScope();
            var seeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
            await seeder.SeedData();
        }
    }
}
