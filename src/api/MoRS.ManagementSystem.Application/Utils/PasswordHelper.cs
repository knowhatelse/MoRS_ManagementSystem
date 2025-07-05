using System.Security.Cryptography;
using System.Text;

namespace MoRS.ManagementSystem.Application.Utils;

public static class PasswordHelper
{
    public static void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
    {
        using var hmac = new HMACSHA512();
        passwordSalt = hmac.Key;
        passwordHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));
    }

    public static bool VerifyPassword(string password, byte[] savedPasswordHash, byte[] savedPasswordSalt)
    {
        using var hmac = new HMACSHA512(savedPasswordSalt);
        var computedHash = hmac.ComputeHash(Encoding.UTF8.GetBytes(password));

        if (computedHash.Length != savedPasswordHash.Length)
        {
            return false;
        }

        for (int i = 0; i < computedHash.Length; i++)
        {
            if (computedHash[i] != savedPasswordHash[i])
            {
                return false;
            }
        }

        return true;
    }
}
