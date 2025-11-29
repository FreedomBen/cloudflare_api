# Changelog

All notable changes to this project will be documented in this file.

Dates are in UTC and are taken from the Git commit history. Versions are
derived from tags and version-bump commits in `mix.exs`.

## [unreleased]

### Added

- Hand-written modules for Cloudflare Accounts and Worker Routes endpoints,
  plus a progress log (`FULL_IMPLEMENTATION_PROGRESS.md`) that tracks manual
  coverage of the OpenAPI spec.
- ExUnit coverage for the new Argo analytics, Smart Routing, AutoRAG, attacker,
  and audit log wrappers to keep recent modules guarded by tests.
- AutoRAG collection management and search helpers to round out the initial
  AutoRAG surface area.
- Automatic SSL/TLS, Page Rules settings, and BinDB helpers to extend coverage
  into SSL settings and Cloudforce One binary analysis workflows.
- Bot Settings, Botnet Threat Feed, and Build Tokens modules with matching
  tests to continue the march across the Cloudflare tag list.
- Builds, CNIs, and Cache Reserve Clear wrappers plus tests so Workers build
  introspection, interconnects, and Smart Shield jobs are now covered.
- Calls apps, TURN keys, and Magic Catalog Sync helpers with full test coverage
  to keep expanding account-level management APIs.
- Cloudflare IPs, Images, and Images Keys modules (with multipart upload
  handling) so media workflows and IP listings are represented in the wrapper.
- Images variants, Cloudflare Tunnels, tunnel configuration, connectivity
  services, content scanning, and country helpers with tests to keep the manual
  rollout moving.
- Custom hostname fallback/origin, custom hostname CRUD/cert helpers, custom
  origin trust stores, custom SSL configs, credential management, custom pages
  (zone/account), D1 database helpers, and custom indicator feeds to expand
  coverage across TLS, Workers storage, and intel APIs.
- DCV Delegation, DEX Remote Commands, and DEX Synthetic Application Monitoring
  modules with comprehensive tests, including binary download handling for
  command artifacts.
- DLP Datasets and DLP Document Fingerprints helpers, covering CRUD flows plus
  binary and multipart uploads for dataset versions and document fingerprints.
- DLP Email account-mapping/rule management plus DLP entry helpers (custom,
  predefined, and integration variants) so the DLP surface is largely covered.
- DLP Profiles and DLP Settings modules, handling profile CRUD/config endpoints
  and account-level limits/pattern validation/payload log APIs.
- DLS Regional Services and DNS Analytics wrappers so regional hostname
  management and DNS analytics reports are available with tests.
- DNS Firewall cluster management plus DNS Firewall analytics modules to cover
  firewall CRUD/reverse DNS and analytics reporting.
- DNS internal views and DNS settings (zone/account) modules to wrap the
  remaining DNS settings endpoints with tests.
- DNSSEC helpers plus Cloudforce One dataset CRUD, continuing the march through
  the remaining DNS/Dataset tags in the progress plan.
- Dataset populate helper and Workers Observability destinations endpoints so
  Cloudforce One batch jobs and logging destinations are covered.
- Device DEX tests and Device Managed Networks modules to round out the
  remaining device-tagged endpoints.
- Device posture integrations and rules modules, keeping the Device section in
  `FULL_IMPLEMENTATION_PROGRESS.md` current.
- Devices module (covering device settings policies, split tunnel lists,
  revoke/unrevoke, override codes, certificates) plus Devices Resilience
  helpers for the global WARP override.
- Diagnostics traceroute helper plus domain history and domain intelligence
  modules to close out the intel-related tags.
- Durable Objects namespace list/object helpers and email routing destination
  address CRUD, continuing the march across the remaining tags.
- Email routing rules and settings modules (including catch-all + DNS toggles)
  to round out the email routing surface.
- Email Security investigation endpoints and Email Security settings (allow,
  block, trusted domains, impersonation registry) now have wrappers and tests.
- Endpoint health checks and build-trigger environment variables helpers,
  covering the diagnostics and environment variable tags.
- Event (Cloudforce One) and Feedback modules to support event analytics plus
  bot-management feedback reporting.
- Filters module for zone-level firewall filters, including query helpers and
  tests for bulk and single filter CRUD endpoints.
- Firewall Rules module spanning list/create/update/delete plus priority helpers,
  including tests for bulk id handling and delete cascades.
- Gateway CA module for Access SSH certificate authorities, covering list/create/delete
  flows and associated tests.
- GitHub integration autofill, Health Checks (including Smart Shield + preview),
  Hyperdrive configs, and IP Access rules (user/zone/account) modules, each with
  request/response coverage and Tesla-based tests.

### Changed

- Reverted the automatic OpenAPI module generation approach in favour of
  explicit modules similar to the original DNS/Zone helpers. Updated the
  README and top-level moduledoc to explain the manual rollout plan.

## [0.3.0] - 2025-11-28

Changes since `v0.2.3`.

### Added

- Added extensive module and function documentation across the public API,
  including `CloudflareApi.DnsRecords`, `CloudflareApi.Zones`, `CloudflareApi.DnsRecord`,
  cache modules, and utility modules, to improve the generated HexDocs.
- Introduced a mix task `mix cloudflare_api.fetch_openapi` for fetching and caching
  Cloudflare's official OpenAPI schema under `priv/cloudflare_api/openapi.json`.
- Significantly expanded the automated test suite with high‑coverage ExUnit tests
  for DNS records, zones, utilities, cache behaviour, and the top-level client.
- Enhanced the README with more complete usage documentation and examples.
- Added local tooling/docs for working with AI assistants (e.g. `CLAUDE.md`
  and related configuration files).

### Changed

- Aligned DNS record and zone listing functions with the official Cloudflare
  OpenAPI specification, including query parameter handling and response
  decoding.
- Introduced project-wide automatic formatting and adjusted existing modules and
  tests to match the formatter configuration.
- Upgraded core dependencies (such as `tesla`, `jason`, `ex_doc`, and tooling
  libraries) to more recent versions.

### Fixed

- Addressed a set of low-effort Credo warnings and minor style issues across
  implementation and test modules.

## [0.2.3] - 2024-08-28

Patch releases in the `0.2.x` series focused on DNS TTL correctness and small
quality-of-life improvements.

### Changed

- Switched DNS record TTL handling from string to integer to better reflect the
  underlying Cloudflare API and avoid ambiguity when encoding requests
  (`0.2.2`).

### Fixed

- Fixed handling of automatic TTL in `CloudflareApi.DnsRecord` so records
  correctly respect Cloudflare's automatic TTL behaviour (`0.2.1` / `0.2.2`).
- Restored Cloudflare's automatic TTL when TTL is not specified, ensuring the
  library no longer sends invalid TTL values on create/update calls (`0.2.3`).
- Quieted a compiler warning on an unused variable and corrected a misleading
  comment in the codebase.

## [0.2.0] - 2024-08-28

### Changed

- Bumped the library version to `0.2.0` after stabilising TTL-related changes
  and minor cleanups.
- Updated the README to reflect the newer API surface and behaviour.

## [0.1.0] - 2024-08-28

### Fixed

- Worked around a change in the Cloudflare API that no longer accepted a TTL
  value of `1`, adjusting the library to send acceptable TTL values while
  preserving previous semantics as closely as possible.
- Corrected an inaccurate comment and performed minor code cleanups.

## [0.0.5] - 2022-04-06

### Added

- Added `list_for_host_domain` variants to `CloudflareApi.DnsRecords`, allowing
  callers to provide separate `host` and `domain` parts and letting the library
  construct the fully-qualified hostname.

### Changed

- Bumped the library version to `v0.0.5`.

## [0.0.4] - 2022-04-06

Initial early release series.

### Added

- Generated the initial project skeleton and implemented the first pass of the
  Cloudflare API wrapper, including DNS record operations and supporting
  utilities.
- Integrated `ex_doc` and added enough description/metadata to publish the
  package on Hex.
- Added an initial Livebook notebook for interactive examples.

### Changed

- Removed an accidental dependency on `Bonny` and pruned unused password-related
  helpers to keep the dependency set minimal.
