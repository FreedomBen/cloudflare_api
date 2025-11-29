# CloudflareApi

`cloudflare_api` is a thin Elixir wrapper around the
[Cloudflare Client API v4](https://api.cloudflare.com/), focused on keeping
you close to the underlying REST endpoints while providing a small set of
ergonomic helpers.

The library currently includes convenience modules for:

- Zones – listing zones and working with `CloudflareApi.Zone` structs.
- DNS records – listing, creating, updating, deleting DNS records via
  `CloudflareApi.DnsRecords` and `CloudflareApi.DnsRecord`.
- An optional in-memory cache for DNS lookups via `CloudflareApi.Cache`.

Recent work is expanding coverage to additional endpoints using the same
hand-written approach. Newly added modules include:

- `CloudflareApi.Accounts` – list accounts or fetch an individual account.
- `CloudflareApi.WorkerRoutes` – list/create/update/delete Workers routes.
- `CloudflareApi.AiGatewayDatasets` – CRUD for AI Gateway datasets under a
  given account and gateway.
- `CloudflareApi.AiGatewayDynamicRoutes` – manage AI Gateway dynamic routes,
  deployments, and versions.
- `CloudflareApi.AiGatewayEvaluations` – list evaluation types and manage
  gateway evaluations.
- `CloudflareApi.AiGatewayGateways` – create, update, and fetch AI Gateway
  configurations (including provider URLs).
- `CloudflareApi.AiGatewayLogs` – list/update/delete log records for a gateway.
- `CloudflareApi.AiGatewayProviderConfigs` – manage provider configs for a
  gateway.
- `CloudflareApi.ApiShieldApiDiscovery` – interact with API Shield discovery
  results and OpenAPI artifacts.
- `CloudflareApi.ApiShieldEndpointManagement` – CRUD for API Shield operations
  and schema exports.
- `CloudflareApi.ApiShieldSchemaValidation` – zone/operation schema validation
  settings plus user schema management.
- `CloudflareApi.ApiShieldSettings` – high-level API Shield configuration
  getter/setter for a zone.
- `CloudflareApi.AsnIntelligence` – fetch ASN overview and subnet details.
- `CloudflareApi.AccessBookmarks` – legacy bookmark application helpers.
- `CloudflareApi.AccessScimUpdateLogs` – list SCIM update logs.
- `CloudflareApi.AccessAppPolicies` – manage policies scoped to an Access app.
- `CloudflareApi.AccessApplications` – create/update/delete Access apps and
  manage tokens/settings.
- `CloudflareApi.AccessAuthenticationLogs` – list Access authentication events.
- `CloudflareApi.AccessCustomPages` – CRUD for custom Access pages.
- `CloudflareApi.AccessGroups` – manage Access groups.
- `CloudflareApi.AccessIdentityProviders` – manage identity providers and SCIM
  resources.
- `CloudflareApi.AccessKeyConfiguration` – view/update/rotate Access keys.
- `CloudflareApi.AccessMtlsAuthentication` – manage Access mTLS certificates
  and settings.
- `CloudflareApi.AccessPolicyTester` – run and inspect policy tests.
- `CloudflareApi.AccessReusablePolicies` – account-level reusable policy CRUD.
- `CloudflareApi.AccessServiceTokens` – manage service tokens (including rotate
  and refresh).
- `CloudflareApi.AccessShortLivedCertificateCas` – CRUD helpers for Access
  short-lived certificate CAs.
- `CloudflareApi.ApiShieldClientCertificates` – client certificate CRUD plus
  hostname associations.
- `CloudflareApi.ApiShieldWafExpressionTemplates` – manage expression
  templates for API Shield WAF.
- `CloudflareApi.AccessTags` – Access tag CRUD.
- `CloudflareApi.Account` / `AccountBillingProfile` – account limits and
  billing profile helpers.
- `CloudflareApi.AccountLoadBalancerMonitorGroups` – monitor group CRUD and
  reference listing.
- `CloudflareApi.AccountLoadBalancerMonitors` – monitor CRUD, preview, and
  references.
- `CloudflareApi.AccountLoadBalancerPools` – pool CRUD, health, previews, and
  references.
- `CloudflareApi.AccountLoadBalancerSearch` – search across load balancer
  resources.
- `CloudflareApi.AccountMembers` – manage account member invites and roles.
- `CloudflareApi.AccountOwnedApiTokens` – manage account tokens, permission
  groups, and verification.
- `CloudflareApi.AccountPermissionGroups` – inspect IAM permission groups.
- `CloudflareApi.AccountRequestTracer` – trigger request traces for an account.
- `CloudflareApi.AccountResourceGroups` – IAM resource group CRUD.
- `CloudflareApi.AccountRoles` – list account roles and details.
- `CloudflareApi.AccountRulesets` – full account ruleset CRUD, entrypoint, and
  version helpers.
- `CloudflareApi.AccountSubscriptions` – manage account subscriptions.
- `CloudflareApi.AccountUserGroups` – IAM user group and member management.
- `CloudflareApi.AccountCustomNameservers` – manage custom nameservers and zone
  usage metadata.
- `CloudflareApi.RealtimeKitActiveSession` – manage meeting sessions
  (kick/mute/polls).
- `CloudflareApi.RealtimeKitAnalytics` – daywise analytics for Realtime Kit
  apps.
- `CloudflareApi.RealtimeKitApps` – list/create Realtime Kit apps.
- `CloudflareApi.AnalyzeCertificate` – analyze SSL certificates for a zone.
- `CloudflareApi.ArgoAnalyticsGeolocation` – Argo latency analytics by colo.
- `CloudflareApi.ArgoAnalyticsZone` – Argo analytics aggregated per zone.
- `CloudflareApi.ArgoSmartRouting` – get/patch Argo Smart Routing settings.
- `CloudflareApi.Attacker` – list Cloudforce One attacker events.
- `CloudflareApi.AuditLogs` – fetch account/user audit logs.
- `CloudflareApi.AutoragJobs` – inspect AutoRAG jobs and logs.
- `CloudflareApi.AutoragRags` – manage AutoRAG collections (create/list/update/delete).
- `CloudflareApi.AutoragRagSearch` – execute AutoRAG search queries.
- `CloudflareApi.AutomaticSslTls` – inspect or update Automatic SSL/TLS enrollment.
- `CloudflareApi.AvailablePageRulesSettings` – list Page Rules settings available to a zone.
- `CloudflareApi.BinDb` – upload binaries to / fetch binaries from Cloudforce One BinDB.
- `CloudflareApi.BotSettings` – manage zone bot management configuration.
- `CloudflareApi.BotnetThreatFeed` – read Botnet Threat Feed reports and ASN configs.
- `CloudflareApi.BuildTokens` – manage Cloudflare Builds tokens.
- `CloudflareApi.Builds` – inspect builds, logs, and cancel jobs for Workers scripts.
- `CloudflareApi.Cnis` – manage Cloudflare Network Interconnects.
- `CloudflareApi.CacheReserveClear` – inspect or trigger Cache Reserve Clear jobs.
- `CloudflareApi.CallsApps` – manage Cloudflare Calls applications.
- `CloudflareApi.CallsTurnKeys` – create/update/delete Calls TURN keys.
- `CloudflareApi.CatalogSync` – orchestrate Magic Cloud catalog syncs.
- `CloudflareApi.CloudflareIps` – fetch Cloudflare public IP ranges.
- `CloudflareApi.CloudflareImages` – upload/list/manage Cloudflare Images assets.
- `CloudflareApi.CloudflareImagesKeys` – manage Cloudflare Images signing keys.
- `CloudflareApi.CloudflareImagesVariants` – create/update/list Images variants.
- `CloudflareApi.CloudflareTunnels` – CRUD Cloudflare/Warp tunnels, tokens, and connections.
- `CloudflareApi.CloudflareTunnelConfiguration` – read/update Zero Trust tunnel configs.
- `CloudflareApi.ConnectivityServices` – manage Connectivity Services directory entries.
- `CloudflareApi.ContentScanning` – enable/disable content upload scanning and payloads.
- `CloudflareApi.Country` – fetch Cloudforce One country data.
- `CloudflareApi.CustomHostnameFallbackOrigin` – manage fallback origin for custom hostnames.
- `CloudflareApi.CustomHostnames` – full CRUD and certificate operations for zone custom hostnames.
- `CloudflareApi.CustomIndicatorFeeds` – manage Cloudforce One custom indicator feeds.
- `CloudflareApi.CustomOriginTrustStore` – manage ACM custom origin trust store certificates.
- `CloudflareApi.CustomSsl` – upload/list/prioritize custom SSL certificates for a zone.
- `CloudflareApi.CredentialManagement` – store R2 data catalog credentials.

Further modules will be added iteratively; progress is tracked in
`FULL_IMPLEMENTATION_PROGRESS.md`.

An up-to-date OpenAPI schema for the Cloudflare API is cached locally at
`priv/cloudflare_api/openapi.json` and used to align request/response shapes.

> NOTE: This library is still evolving and does not yet cover every Cloudflare
> endpoint. It aims to stay close to the official API and avoid heavy
> abstraction.

## Installation

Add `cloudflare_api` to your `mix.exs`:

```elixir
def deps do
  [
    {:cloudflare_api, "~> 0.3.0"}
  ]
end
```

Then fetch dependencies:

```bash
mix deps.get
```

### Supported Elixir / OTP

The project targets Elixir `~> 1.12` and a reasonably recent OTP release.
If you are on a newer Elixir (1.13+), it should work as long as your OTP
version is supported by that Elixir release.

## Getting Started

Configure your Cloudflare API token via an environment variable (recommended):

```bash
export CLOUDFLARE_API_TOKEN="your-cloudflare-api-token"
```

Create a client and list zones:

```elixir
iex> client = CloudflareApi.client(System.fetch_env!("CLOUDFLARE_API_TOKEN"))
iex> {:ok, zones} = CloudflareApi.Zones.list(client, nil)
iex> Enum.map(zones, & &1["name"])
["example.com", "another.example.com"]
```

Work with DNS records:

```elixir
# List DNS records for a zone
iex> zone_id = "your-zone-id"
iex> {:ok, records} = CloudflareApi.DnsRecords.list(client, zone_id, name: "www.example.com")

# Create a new A record
iex> {:ok, record} =
...>   CloudflareApi.DnsRecords.create(
...>     client,
...>     zone_id,
...>     "www.example.com",
...>     "203.0.113.10"
...>   )

# Update an existing record
iex> {:ok, updated} =
...>   CloudflareApi.DnsRecords.update(
...>     client,
...>     zone_id,
...>     record.id,
...>     record.hostname,
...>     "203.0.113.11"
...>   )

# Delete a record
iex> CloudflareApi.DnsRecords.delete(client, zone_id, record.id)
{:ok, "record-id"}
```

## Build & Development

Install dependencies:

```bash
mix deps.get
```

Compile:

```bash
mix compile
```

Start an interactive shell with the app loaded:

```bash
iex -S mix
```

### Working with the OpenAPI spec

To refresh the vendored OpenAPI schema from the official Cloudflare
repository:

```bash
mix fetch_openapi
# or explicitly:
mix cloudflare_api.fetch_openapi
```

This writes the schema to `priv/cloudflare_api/openapi.json`.

## Testing & Quality Checks

Run the test suite:

```bash
mix test
```

Format the code (and verify formatting):

```bash
mix format
mix format --check-formatted
```

Run Credo (static analysis) in dev or test:

```bash
mix credo
```

Run Dialyzer (if you have PLT caches set up):

```bash
MIX_ENV=dev mix dialyzer
```

Generate docs:

```bash
mix docs
```

## Contributing

Contributions are welcome. Before opening a pull request:

- Read `AGENTS.md` for contributor and tooling guidelines.
- Add or update tests for any new behavior; avoid real Cloudflare network
  calls in tests (use `Tesla.Mock` instead).
- Run `mix test` and `mix format` locally.
- Add a short note under the `[unreleased]` section in `CHANGELOG.md` for any
  user‑visible change (including new docs or endpoints).

## Publishing to Hex.pm

These are general steps for publishing `cloudflare_api` to
[hex.pm](https://hex.pm/). You only need to do this if you are a maintainer
with publishing rights.

1. **Ensure Hex tooling is installed**

   ```bash
   mix local.hex
   mix local.rebar
   ```

2. **Bump the version**

   - Update `@version` in `mix.exs`.
   - Update any version references in `README.md` (Installation section).
   - Optionally add or update a `CHANGELOG` entry.

3. **Run checks**

   ```bash
   mix deps.get
   mix test
   mix credo
   MIX_ENV=dev mix dialyzer     # optional but recommended
   mix docs
   ```

4. **Build the Hex package**

   ```bash
   mix hex.build
   ```

5. **Authenticate with Hex (first time only)**

   ```bash
   mix hex.user register   # or: mix hex.user auth
   ```

6. **Publish to Hex**

   ```bash
   mix hex.publish
   # Answer the prompts to confirm publishing
   ```

7. **Tag and push the release (optional but recommended)**

   ```bash
   git tag v0.2.4          # example
   git push origin v0.2.4
   ```

Once published, docs will be available at:

<https://hexdocs.pm/cloudflare_api>

and the package page at:

<https://hex.pm/packages/cloudflare_api>

## Security Notes

- Never commit real API tokens or secrets.
- Prefer environment variables (for example `CLOUDFLARE_API_TOKEN`) or
  other secure runtime configuration.
- When adding examples, use obviously fake tokens and hostnames and keep
  them out of library business logic.
