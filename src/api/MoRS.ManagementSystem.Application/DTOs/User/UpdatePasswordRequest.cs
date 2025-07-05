using System.ComponentModel.DataAnnotations;
using System.Text.RegularExpressions;

namespace MoRS.ManagementSystem.Application.DTOs.User;

public class PasswordComplexityAttribute : ValidationAttribute
{
    protected override ValidationResult? IsValid(object? value, ValidationContext validationContext)
    {
        var password = value as string;
        if (string.IsNullOrEmpty(password))
            return new ValidationResult("Password is required.");
        if (password.Length < 6 || password.Length > 100)
            return new ValidationResult("Password must be between 6 and 100 characters.");
        if (!Regex.IsMatch(password, "[A-Z]"))
            return new ValidationResult("Password must contain at least one uppercase letter.");
        if (!Regex.IsMatch(password, "[a-z]"))
            return new ValidationResult("Password must contain at least one lowercase letter.");
        if (!Regex.IsMatch(password, "\\d"))
            return new ValidationResult("Password must contain at least one digit.");
        if (!Regex.IsMatch(password, "[^a-zA-Z0-9]"))
            return new ValidationResult("Password must contain at least one non-alphanumeric character.");
        return ValidationResult.Success;
    }
}

public class UpdatePasswordRequest
{
    [Required]
    [StringLength(100, MinimumLength = 6)]
    public required string NewPassword { get; set; }
}
