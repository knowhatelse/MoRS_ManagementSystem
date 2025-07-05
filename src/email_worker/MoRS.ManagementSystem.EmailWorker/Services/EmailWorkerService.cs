using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Text.Json;
using EmailWorker.Models;
using EmailWorker.Configuration;

namespace EmailWorker.Services;

public class EmailWorkerService : BackgroundService
{
    private readonly ILogger<EmailWorkerService> _logger;
    private readonly IEmailSender _emailSender;
    private readonly ConnectionFactory _connectionFactory;
    private readonly RabbitMqSettings _rabbitMqSettings;
    private IConnection? _connection;
    private IChannel? _channel;

    public EmailWorkerService(
        ILogger<EmailWorkerService> logger,
        IEmailSender emailSender,
        IOptions<RabbitMqSettings> rabbitMqSettings)
    {
        _logger = logger;
        _emailSender = emailSender;
        _rabbitMqSettings = rabbitMqSettings.Value;
        _connectionFactory = new ConnectionFactory
        {
            HostName = _rabbitMqSettings.HostName,
            Port = _rabbitMqSettings.Port,
            UserName = _rabbitMqSettings.UserName,
            Password = _rabbitMqSettings.Password
        };
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Email Worker starting...");

        try
        {
            _connection = await _connectionFactory.CreateConnectionAsync();
            _channel = await _connection.CreateChannelAsync();

            await _channel.QueueDeclareAsync(
                queue: "email-created",
                durable: false,
                exclusive: false,
                autoDelete: false,
                arguments: null);

            _logger.LogInformation("Email Worker connected to RabbitMQ and listening for messages...");

            var consumer = new AsyncEventingBasicConsumer(_channel);
            consumer.ReceivedAsync += async (model, ea) =>
            {
                try
                {
                    var body = ea.Body.ToArray();
                    var message = Encoding.UTF8.GetString(body);
                    var emailEvent = JsonSerializer.Deserialize<EmailCreatedEvent>(message);

                    if (emailEvent != null)
                    {
                        await ProcessEmailEventAsync(emailEvent);
                        await _channel.BasicAckAsync(deliveryTag: ea.DeliveryTag, multiple: false);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error processing email event");
                    await _channel.BasicNackAsync(deliveryTag: ea.DeliveryTag, multiple: false, requeue: false);
                }
            };

            await _channel.BasicConsumeAsync(
                queue: "email-created",
                autoAck: false,
                consumer: consumer
            );

            while (!stoppingToken.IsCancellationRequested)
            {
                await Task.Delay(1000, stoppingToken);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to connect to RabbitMQ or process messages");
        }
    }

    private async Task ProcessEmailEventAsync(EmailCreatedEvent emailEvent)
    {
        _logger.LogInformation("Processing email event:");
        _logger.LogInformation("Subject: {Subject}", emailEvent.Subject);
        _logger.LogInformation("Body: {Body}", emailEvent.Body);
        _logger.LogInformation("Recipients: {Recipients}", string.Join(", ", emailEvent.UserEmails ?? []));

        await SendRealEmailsAsync(emailEvent);
    }

    private async Task SendRealEmailsAsync(EmailCreatedEvent emailEvent)
    {
        if (emailEvent.UserEmails == null || !emailEvent.UserEmails.Any())
        {
            _logger.LogWarning("⚠️ No email recipients found");
            return;
        }

        _logger.LogInformation("🚀 Starting real email sending process...");

        try
        {
            var success = await _emailSender.SendEmailToMultipleAsync(
                emailEvent.UserEmails,
                emailEvent.Subject ?? "No Subject",
                emailEvent.Body ?? "No Content"
            );

            if (success)
            {
                _logger.LogInformation("🎉 All emails sent successfully to {Count} recipients!",
                    emailEvent.UserEmails.Count);
            }
            else
            {
                _logger.LogError("❌ Failed to send emails to some or all recipients");
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "💥 Exception occurred while sending emails");

            _logger.LogInformation("🔄 Attempting to send emails individually as fallback...");
            await SendEmailsIndividuallyAsync(emailEvent);
        }
    }

    private async Task SendEmailsIndividuallyAsync(EmailCreatedEvent emailEvent)
    {
        if (emailEvent.UserEmails == null) return;

        int successCount = 0;
        int failureCount = 0;

        foreach (var email in emailEvent.UserEmails)
        {
            try
            {
                _logger.LogInformation("📧 Sending email to: {Email}", email);

                var success = await _emailSender.SendEmailAsync(
                    email,
                    emailEvent.Subject ?? "No Subject",
                    emailEvent.Body ?? "No Content"
                );

                if (success)
                {
                    successCount++;
                    _logger.LogInformation("✅ Email sent successfully to: {Email}", email);
                }
                else
                {
                    failureCount++;
                    _logger.LogError("❌ Failed to send email to: {Email}", email);
                }

                await Task.Delay(200);
            }
            catch (Exception ex)
            {
                failureCount++;
                _logger.LogError(ex, "💥 Exception sending email to: {Email}", email);
            }
        }

        _logger.LogInformation("📊 Email sending summary: {Success} successful, {Failed} failed",
            successCount, failureCount);
    }

    public override async Task StopAsync(CancellationToken cancellationToken)
    {
        _logger.LogInformation("Email Worker is stopping...");

        if (_channel != null)
        {
            await _channel.CloseAsync();
            _channel.Dispose();
        }

        if (_connection != null)
        {
            await _connection.CloseAsync();
            _connection.Dispose();
        }

        await base.StopAsync(cancellationToken);
    }
}
