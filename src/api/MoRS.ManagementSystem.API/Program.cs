using Microsoft.EntityFrameworkCore;
using MoRS.ManagementSystem.API.Extensions;
using MoRS.ManagementSystem.Infrastructure.Extensions;
using MoRS.ManagementSystem.Application.Extensions;

var builder = WebApplication.CreateBuilder(args);
var connectionString = builder.Configuration.GetConnectionString("MoRSManagementSystemDatabase");

builder.Services.AddMoRSManagementSystemDbContext(connectionString!);
builder.Services.AddDataSeeder();
builder.Services.AddRepositories();
builder.Services.AddServices();
builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddAutoMapper(typeof(Program).Assembly);

var app = builder.Build();

app.ConfigurePipeline();
app.Run();
