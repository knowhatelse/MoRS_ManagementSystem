using MoRS.ManagementSystem.Infrastructure.Extensions;

namespace MoRS.ManagementSystem.API.Extensions;

public static class ApplicationBuilderExtensions
{
    public static IApplicationBuilder ConfigurePipeline(this WebApplication app)
    {
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/openapi/v1.json", "MoRS Management System API");
            });
        }

        app.UseHttpsRedirection();
        app.UseAuthorization();
        app.MapControllers();
        app.SeedDatabaseAsync().Wait();

        return app;
    }
}
