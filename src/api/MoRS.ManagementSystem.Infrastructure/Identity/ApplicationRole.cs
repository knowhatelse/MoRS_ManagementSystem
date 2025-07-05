using Microsoft.AspNetCore.Identity;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Infrastructure.Identity;

public class ApplicationRole : IdentityRole<int>
{
    public ICollection<ApplicationUser> Users { get; set; } = [];
}
