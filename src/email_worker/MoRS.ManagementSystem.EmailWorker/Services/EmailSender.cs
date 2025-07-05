using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using EmailWorker.Configuration;

namespace EmailWorker.Services;

public interface IEmailSender
{
    Task<bool> SendEmailAsync(string toEmail, string subject, string body);
    Task<bool> SendEmailToMultipleAsync(List<string> toEmails, string subject, string body);
}

public class EmailSender(IOptions<EmailSettings> emailSettings, ILogger<EmailSender> logger) : IEmailSender
{
    private readonly EmailSettings _emailSettings = emailSettings.Value;
    private readonly ILogger<EmailSender> _logger = logger;

    public async Task<bool> SendEmailAsync(string toEmail, string subject, string body)
    {
        return await SendEmailToMultipleAsync(new List<string> { toEmail }, subject, body);
    }

    public async Task<bool> SendEmailToMultipleAsync(List<string> toEmails, string subject, string body)
    {
        _logger.LogInformation("🔧 DEBUG: Starting email send process");
        _logger.LogInformation("🔧 DEBUG: Email Settings - Server: {Server}, Port: {Port}, SSL: {SSL}",
            _emailSettings.SmtpServer, _emailSettings.SmtpPort, _emailSettings.EnableSsl);
        _logger.LogInformation("🔧 DEBUG: Sender Email: {SenderEmail}", _emailSettings.SenderEmail);
        _logger.LogInformation("🔧 DEBUG: Recipients: {Recipients}", string.Join(", ", toEmails));
        _logger.LogInformation("🔧 DEBUG: Subject: {Subject}", subject);

        try
        {
            var message = new MimeMessage();

            _logger.LogInformation("🔧 DEBUG: Setting sender information");
            message.From.Add(new MailboxAddress(_emailSettings.SenderName, _emailSettings.SenderEmail));

            _logger.LogInformation("🔧 DEBUG: Adding recipients");
            foreach (var email in toEmails)
            {
                if (!string.IsNullOrWhiteSpace(email))
                {
                    _logger.LogInformation("🔧 DEBUG: Adding recipient: {Email}", email);
                    message.To.Add(MailboxAddress.Parse(email));
                }
                else
                {
                    _logger.LogWarning("🔧 DEBUG: Skipping empty email address");
                }
            }

            if (message.To.Count == 0)
            {
                _logger.LogError("🔧 DEBUG: No valid recipients found!");
                return false;
            }

            _logger.LogInformation("🔧 DEBUG: Setting message content");
            message.Subject = subject;
            var bodyBuilder = new BodyBuilder
            {
                HtmlBody = ConvertToHtml(body),
                TextBody = body
            };
            message.Body = bodyBuilder.ToMessageBody();

            _logger.LogInformation("🔧 DEBUG: Creating SMTP client");
            using var client = new SmtpClient();

            var secureSocketOptions = _emailSettings.SmtpPort == 465 ? SecureSocketOptions.SslOnConnect : SecureSocketOptions.StartTls;
            _logger.LogInformation("🔧 DEBUG: Using SecureSocketOptions: {Options}", secureSocketOptions);
            _logger.LogInformation("🔧 DEBUG: Connecting to SMTP server: {SmtpServer}:{SmtpPort}",
                _emailSettings.SmtpServer, _emailSettings.SmtpPort);

            await client.ConnectAsync(_emailSettings.SmtpServer, _emailSettings.SmtpPort, secureSocketOptions);
            _logger.LogInformation("🔧 DEBUG: Successfully connected to SMTP server");

            if (!string.IsNullOrEmpty(_emailSettings.SenderPassword))
            {
                _logger.LogInformation("🔧 DEBUG: Authenticating with email: {Email}", _emailSettings.SenderEmail);
                _logger.LogInformation("🔧 DEBUG: Password length: {Length} characters", _emailSettings.SenderPassword.Length);

                await client.AuthenticateAsync(_emailSettings.SenderEmail, _emailSettings.SenderPassword);
                _logger.LogInformation("🔧 DEBUG: Authentication successful");
            }
            else
            {
                _logger.LogWarning("🔧 DEBUG: No password provided for authentication");
            }

            _logger.LogInformation("🔧 DEBUG: Sending message...");
            await client.SendAsync(message);
            _logger.LogInformation("🔧 DEBUG: Message sent successfully");

            _logger.LogInformation("🔧 DEBUG: Disconnecting from SMTP server");
            await client.DisconnectAsync(true);

            _logger.LogInformation("✅ Email sent successfully to {Recipients}", string.Join(", ", toEmails));
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "❌ Failed to send email to {Recipients}. Error: {ErrorMessage}",
                string.Join(", ", toEmails), ex.Message);

            if (ex.InnerException != null)
            {
                _logger.LogError("❌ Inner Exception: {InnerError}", ex.InnerException.Message);
            }

            return false;
        }
    }

    private static string ConvertToHtml(string plainText)
    {
        return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>MoRS Management System</title>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        .header {{ background-color: #007bff; color: white; padding: 15px; text-align: center; }}
        .content {{ padding: 20px; background-color: #f9f9f9; }}
        .footer {{ text-align: center; padding: 10px; font-size: 12px; color: #666; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h2>MoRS Management System</h2>
        </div>
        <div class='content'>
            {plainText.Replace("\n", "<br>")}
        </div>
        <div class='footer'>
            <p>This email was sent automatically by MoRS Management System.</p>
        </div>
    </div>
</body>
</html>";
    }
}
