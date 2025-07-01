using Microsoft.AspNetCore.Identity;
using MoRS.ManagementSystem.Domain.Entities;

namespace MoRS.ManagementSystem.Infrastructure.Identity;

public class ApplicationUser : IdentityUser<int>
{
    public required string Name { get; set; }
    public required string Surname { get; set; }
}
