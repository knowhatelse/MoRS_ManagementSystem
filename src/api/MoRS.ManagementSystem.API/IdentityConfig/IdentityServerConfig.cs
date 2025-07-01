using IdentityServer4.Models;

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

    public static IEnumerable<Client> Clients => new List<Client>
    {
        new Client
        {
            ClientId = "mors_client_desktop",
            AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
            ClientSecrets = { new Secret("desktop_secret".Sha256()) },
            AllowedScopes = { "api", "openid", "profile" }
        },
        new Client
        {
            ClientId = "mors_client_mobile",
            AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
            ClientSecrets = { new Secret("mobile_secret".Sha256()) },
            AllowedScopes = { "api", "openid", "profile" }
        },
        new Client
        {
            ClientId = "mors_client",
            AllowedGrantTypes = GrantTypes.ResourceOwnerPassword,
            ClientSecrets = { new Secret("secret".Sha256()) },
            AllowedScopes = { "api", "openid", "profile" }
        }
    };
}
