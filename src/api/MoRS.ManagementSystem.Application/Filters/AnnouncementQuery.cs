using System;

namespace MoRS.ManagementSystem.Application.Filters;

public class AnnouncementQuery
{
    public bool? IsDeleted { get; set; }
    public bool? IsUserIncluded { get; set; }
}
