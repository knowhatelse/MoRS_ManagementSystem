using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.API.Extensions;
using MoRS.ManagementSystem.Infrastructure.Extensions;
using MoRS.ManagementSystem.Application.Extensions;
using MoRS.ManagementSystem.Application.Events;
using MoRS.ManagementSystem.Infrastructure.Data;
using MoRS.ManagementSystem.Infrastructure.Identity;
using MoRS.ManagementSystem.API.IdentityConfig;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Security.Cryptography;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("MoRSManagementSystemDatabase");

builder.Services.AddMoRSManagementSystemDbContext(connectionString!);
builder.Services.AddIdentity<ApplicationUser, ApplicationRole>()
    .AddEntityFrameworkStores<MoRSManagementSystemDbContext>()
    .AddDefaultTokenProviders();

var rsa = RSA.Create();
var keyPath = Path.Combine(AppContext.BaseDirectory, "identityserver_signing_key.xml");
if (File.Exists(keyPath))
{
    rsa.FromXmlString(File.ReadAllText(keyPath));
}
else
{
    var keyParams = rsa.ExportParameters(true);
    File.WriteAllText(keyPath, rsa.ToXmlString(true));
}
var rsaSecurityKey = new RsaSecurityKey(rsa);
var signingCredentials = new SigningCredentials(rsaSecurityKey, SecurityAlgorithms.RsaSha256);

var publicKey = rsa.ExportParameters(false);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidIssuers = builder.Configuration.GetSection("JWT:ValidIssuers").Get<string[]>(),
        ValidateAudience = true,
        ValidAudience = builder.Configuration["JWT:ValidAudience"],
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = rsaSecurityKey,
        ValidateLifetime = true
    };
    options.Events = new JwtBearerEvents
    {
        OnAuthenticationFailed = context =>
        {
            return Task.CompletedTask;
        },
        OnTokenValidated = context =>
        {
            return Task.CompletedTask;
        },
        OnChallenge = context =>
        {
            return Task.CompletedTask;
        }
    };
});


builder.Services.AddIdentityServer()
    .AddSigningCredential(signingCredentials)
    .AddInMemoryIdentityResources(IdentityServerConfig.IdentityResources)
    .AddInMemoryApiScopes(IdentityServerConfig.ApiScopes)
    .AddInMemoryApiResources(IdentityServerConfig.ApiResources)
    .AddInMemoryClients(IdentityServerConfig.GetClients(builder.Configuration))
    .AddAspNetIdentity<ApplicationUser>();

builder.Services.AddDataSeeder();
builder.Services.AddRepositories();
builder.Services.AddServices();
builder.Services.AddCorsPolicy();
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
builder.Services.AddUserManagementService();

builder.Services.AddSingleton<IEventBus>(new RabbitMqEventBus(
    builder.Configuration["RabbitMQ:HostName"] ?? "localhost",
    builder.Configuration["RabbitMQ:UserName"] ?? "guest",
    builder.Configuration["RabbitMQ:Password"] ?? "guest"
));

var app = builder.Build();


if (args.Contains("--seed"))
{
    using (var scope = app.Services.CreateScope())
    {
        var dataSeeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
        await dataSeeder.SeedData();
        Console.WriteLine("Database seeding completed successfully!");
        return;
    }
}


using (var scope = app.Services.CreateScope())
{
    try
    {
        var context = scope.ServiceProvider.GetRequiredService<MoRSManagementSystemDbContext>();

        await context.Database.MigrateAsync();
        Console.WriteLine("Database migrations applied successfully!");

        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        if (!userManager.Users.Any())
        {
            Console.WriteLine("Database is empty, starting seeding process...");
            var dataSeeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
            await dataSeeder.SeedData();
            Console.WriteLine("Database seeding completed successfully!");
        }
        else
        {
            Console.WriteLine("Database already contains data, skipping seeding.");
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error during database initialization: {ex.Message}");
    }
}

app.UseIdentityServer();
app.UseAuthentication();
app.UseAuthorization();

app.ConfigurePipeline();
app.Run();

public partial class Program { }
