using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.Infrastructure.Extensions;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("MoRSManagementSystemDatabase");

builder.Services.AddMoRSManagementSystemDbContext(connectionString!);
builder.Services.AddDataSeeder();
builder.Services.AddRepositories();
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddAutoMapper(typeof(Program).Assembly);

var app = builder.Build();

app.SeedDatabaseAsync().Wait();
app.ConfigurePipeline();
app.Run();
