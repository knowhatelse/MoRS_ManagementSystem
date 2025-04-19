namespace MoRS.ManagementSystem.Application.Filters;

public class UserQuery
{
    public string? Name { get; set; }
    public string? Surname { get; set; }
    public string? Email { get; set; }

    public bool IsProfilePictureIncluded { get; set; } = true;
    public bool IsRoleIncluded { get; set; } = true;
}
