using IdentityServer4.Models;
using Microsoft.Extensions.Configuration;

namespace MoRS.ManagementSystem.API.IdentityConfig;

public static class IdentityServerConfig
{
    public static IEnumerable<IdentityResource> IdentityResources => new List<IdentityResource>
    {
        new IdentityResources.OpenId(),
        new IdentityResources.Profile(),
    };

    public static IEnumerable<ApiScope> ApiScopes => new List<ApiScope>
    {
        new ApiScope("api", "Main API")
    };

    public static IEnumerable<ApiResource> ApiResources => new List<ApiResource>
    {
        new ApiResource("api", "Main API")
        {
            Scopes = { "api" }
        }
    };

    public static IEnumerable<Client> GetClients(IConfiguration configuration)
    {
        var desktopClientId = configuration["IdentityServer:Clients:Desktop:ClientId"];
        var desktopClientSecret = configuration["IdentityServer:Clients:Desktop:ClientSecret"];
        var mobileClientId = configuration["IdentityServer:Clients:Mobile:ClientId"];
        var mobileClientSecret = configuration["IdentityServer:Clients:Mobile:ClientSecret"];
        var genericClientId = configuration["IdentityServer:Clients:Generic:ClientId"];
        var genericClientSecret = configuration["IdentityServer:Clients:Generic:ClientSecret"];

        return new List<Client>
        {
            new Client
            {
                ClientId = desktopClientId,
                AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
                ClientSecrets = { new Secret(desktopClientSecret.Sha256()) },
                AllowedScopes = { "api", "openid", "profile" }
            },
            new Client
            {
                ClientId = mobileClientId,
                AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
                ClientSecrets = { new Secret(mobileClientSecret.Sha256()) },
                AllowedScopes = { "api", "openid", "profile" }
            },
            new Client
            {
                ClientId = genericClientId,
                AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
                ClientSecrets = { new Secret(genericClientSecret.Sha256()) },
                AllowedScopes = { "api", "openid", "profile" }
            }
        };
    }
}
