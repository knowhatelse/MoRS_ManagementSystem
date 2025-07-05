using MoRS.ManagementSystem.API.Middlewares;
using MoRS.ManagementSystem.Infrastructure.Extensions;

namespace MoRS.ManagementSystem.API.Extensions;

public static class ApplicationBuilderExtensions
{
    public static IApplicationBuilder ConfigurePipeline(this WebApplication app)
    {
        app.UseMiddleware<ExceptionHandlingMiddleware>();

        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/openapi/v1.json", "MoRS Management System API");
            });
        }

        if (app.Environment.IsDevelopment())
        {
            app.UseHttpsRedirection();
        }

        app.UseCors("MoRSCorsPolicy");
        app.UseAuthorization();
        app.MapControllers();

        return app;
    }
}
