using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using EmailWorker.Models;
using EmailWorker.Services;
using EmailWorker.Configuration;

var builder = Host.CreateApplicationBuilder(args);

builder.Services.Configure<EmailSettings>(
    builder.Configuration.GetSection("EmailSettings"));

builder.Services.Configure<RabbitMqSettings>(
    builder.Configuration.GetSection("RabbitMQ"));

builder.Services.AddScoped<IEmailSender, EmailSender>();
builder.Services.AddSingleton<EmailWorkerService>();
builder.Services.AddHostedService<EmailWorkerService>();
builder.Services.AddLogging(logging =>
{
    logging.AddConsole();
    logging.SetMinimumLevel(LogLevel.Information);
});

var host = builder.Build();

var serviceProvider = host.Services;
using (var scope = serviceProvider.CreateScope())
{
    var emailSettings = scope.ServiceProvider.GetRequiredService<IOptions<EmailSettings>>().Value;
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();

    logger.LogInformation("🔧 DEBUG: Email Configuration Loaded:");
    logger.LogInformation("🔧 DEBUG: SMTP Server: {Server}", emailSettings.SmtpServer);
    logger.LogInformation("🔧 DEBUG: SMTP Port: {Port}", emailSettings.SmtpPort);
    logger.LogInformation("🔧 DEBUG: Sender Email: {Email}", emailSettings.SenderEmail);
    logger.LogInformation("🔧 DEBUG: Password Set: {HasPassword}", !string.IsNullOrEmpty(emailSettings.SenderPassword));
    logger.LogInformation("🔧 DEBUG: Password Length: {Length}", emailSettings.SenderPassword?.Length ?? 0);
    logger.LogInformation("🔧 DEBUG: SSL Enabled: {SSL}", emailSettings.EnableSsl);
}

await host.RunAsync();
