namespace MoRS.ManagementSystem.Application.Filters;

public class RoomQuery : BaseQuery
{
    public bool? IsActive { get; set; } = true;
}
