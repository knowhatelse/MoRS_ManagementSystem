namespace MoRS.ManagementSystem.Application.Filters;

public class NotificationQuery
{
    public bool? IsRead { get; set; }
    public int? UserId { get; set; }
    public bool? IsUserIncluded { get; set; }

}
