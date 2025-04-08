namespace MoRS.ManagementSystem.Application.Filters;

public class UserQuery : BaseQuery
{
    public string? Name { get; set; }
    public string? Surname { get; set; }

    public bool IsProfilePictureIncluded { get; set; } = true;
}
