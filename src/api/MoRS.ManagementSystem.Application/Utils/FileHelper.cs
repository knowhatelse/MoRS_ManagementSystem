namespace MoRS.ManagementSystem.Application.Utils;

public static class FileHelper
{
    public static string DetectFileType(byte[] data)
    {
        if (data.Length > 4 && data[0] == 0x89 && data[1] == 0x50) return "image/png";
        if (data.Length > 3 && data[0] == 0xFF && data[1] == 0xD8) return "image/jpeg";
        return "application/octet-stream";
    }

    public static string GetExtensionFromType(string fileType)
    {
        return fileType switch
        {
            "image/png" => "png",
            "image/jpeg" => "jpg",
            _ => "bin"
        };
    }

}
