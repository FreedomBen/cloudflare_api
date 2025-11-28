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
