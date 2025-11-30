# Full Cloudflare API Implementation Plan

This document describes how to extend `cloudflare_api` from the current
hand‑picked set of DNS/zone helpers to a thin, well‑tested wrapper that covers
every operation exposed in the vendored OpenAPI schema at
`priv/cloudflare_api/openapi.json`.

The goals are:

- Implement a callable Elixir function for each OpenAPI operation.
- Keep the wrapper intentionally thin and close to the HTTP surface.
- Add robust, OpenAPI‑aligned tests (happy path and error cases).
- Avoid adding any caching behaviour to the new endpoints.
- Ensure all new modules and functions are well documented for HexDocs.

---

## 1. Source of Truth & Scope

- Treat `priv/cloudflare_api/openapi.json` as the **single source of truth**
  for:
  - Available paths, methods, and operationIds.
  - Supported parameters, request bodies, and response shapes.
  - Error envelopes and common response wrappers.
- Scope includes **all HTTP operations** defined in the schema (not just
  `/zones` and `/dns_records`).
- Changes to the OpenAPI file should be refreshed via
  `mix cloudflare_api.fetch_openapi` and then reconciled with this plan as
  needed.

Deliverable from this phase:

- A small internal helper module (e.g. `CloudflareApi.OpenApi.Introspect`)
  that can:
  - Load and decode `openapi.json` (via `Jason.decode!/1`).
  - Enumerate operations as `%{path, method, operation_id, tags, summary}`.
  - Expose helpers for looking up components/schemas for responses and
    request bodies.

This helper is **not** part of the public API; it is used during
implementation and in tests.

---

## 2. Module Layout & Naming Strategy

### 2.1. Tag‑Driven Modules

- Use the primary OpenAPI **tag** as the basis for module names to keep the
  surface discoverable and close to Cloudflare’s own grouping:
  - Tag `"Accounts"` → `CloudflareApi.Accounts`
  - Tag `"Zones"` → `CloudflareApi.Zones` (already exists)
  - Tag `"DNS Records for a Zone"` → `CloudflareApi.DnsRecords` (already exists)
  - And so on for the remaining tags.
- For operations that share multiple tags, prefer the first tag in the list as
  the module anchor, unless there is already a hand‑written module that more
  clearly matches the resource (e.g. keep all DNS record operations under
  `CloudflareApi.DnsRecords`).
- Where a tag name is not a valid Elixir module component:
  - Strip/replace non‑alphanumeric characters.
  - Convert to `CamelCase`.
  - Document the mapping logic in this plan and in a small internal helper
    (e.g. `CloudflareApi.OpenApi.Naming`).

### 2.2. Function Naming per Operation

- Derive function names primarily from the OpenAPI `operationId`, with a
  small set of transformations to make them idiomatic:
  - Lowercase, replace non‑alphanumeric characters with `_`.
  - Collapse multiple underscores.
  - Trim common redundant prefixes that are already implied by the module:
    - In `CloudflareApi.Accounts`, `accounts_list_accounts` → `list_accounts`.
    - In `CloudflareApi.Zones`, `zones_get_zone_details` → `get_zone_details`.
  - Guarantee uniqueness per module; if two operations would collide, keep a
    more literal transformation (e.g. include HTTP verb or full operationId).
- Arity should reflect the HTTP signature:
  - Path params → required arguments in the order they appear in the path.
  - Query params → final `opts \\ []` keyword list.
  - Request body (if present) → final positional argument before `opts`, typed
    as:
    - A plain map following the OpenAPI schema, and/or
    - A dedicated struct module if we decide to model it (see 3.3).

Examples:

- `GET /accounts` (`operationId: "accounts-list-accounts"`) →
  `CloudflareApi.Accounts.list_accounts(client, opts \\ [])`.
- `POST /zones/{zone_id}/purge_cache` →
  `CloudflareApi.Zones.purge_cache(client, zone_id, body)`.

### 2.3. Reuse Existing Modules

- Keep and extend the hand‑written modules:
  - `CloudflareApi.DnsRecords`
  - `CloudflareApi.DnsRecord`
  - `CloudflareApi.Zones`
  - `CloudflareApi.Zone`
- For operations that logically belong to these (e.g. additional DNS record or
  zone metadata endpoints), prefer adding new functions to the existing
  modules instead of creating parallel ones.
- For completely new resource areas (e.g. Firewall Rules, Workers, KV),
  introduce new modules following the tag naming conventions.

---

## 3. Request Construction

### 3.1. Client Handling

- Reuse the existing `CloudflareApi.new/1` and `CloudflareApi.client/1`
  helpers.
- All new endpoint functions will accept either:
  - A `Tesla.Client.t()` built via `CloudflareApi.new/1`, or
  - A zero‑arity function returned by `CloudflareApi.client/1`.
- Use the same `c/1` helper pattern already present in `CloudflareApi.Zones`
  and `CloudflareApi.DnsRecords` to normalise clients.

### 3.2. Paths & Path Parameters

- Use OpenAPI path templates directly and interpolate `{param}` segments using
  Elixir string interpolation:
  - `/accounts/{account_identifier}` → `" /accounts/#{account_identifier}"`.
- Ensure path parameter names in function arguments exactly match those in the
  spec where possible (e.g. `zone_identifier`, `account_identifier`).
- For each operation:
  - Validate that all required path params are present (at least via
    function arity; additional guards can be added if necessary).

### 3.3. Query Parameters

- Accept query parameters as a keyword list (`opts \\ []`) and pass them
  through `CloudflareApi.uri_encode_opts/1`, which already encodes dotted
  keys (`"account.id"`, `"name.contains"`, etc.) correctly.
- For each operation, document the key names and a brief description in the
  `@doc` string, based on the OpenAPI parameter list.
- Tests (see section 5) will validate that representative options produce the
  correct query string as defined by the spec.

### 3.4. Request Bodies

- For operations with a `requestBody`:
  - Start with a **map‑first** approach: accept a plain map that must conform
    to the OpenAPI schema, and send it as the JSON body.
  - Optionally introduce lightweight struct modules for frequently‑used or
    complex bodies (e.g. DNS record, firewall rule) where the added clarity
    justifies the cost. These should:
    - Mirror the OpenAPI schema fields.
    - Provide `to_cf_json/1` and `from_cf_json/1` as in `CloudflareApi.DnsRecord`.
- Do **not** apply caching or local mutation based on request bodies; simply
  forward them to Cloudflare.

---

## 4. Response Handling & Error Normalisation

### 4.1. Envelope Pattern

- Most Cloudflare API responses share a common envelope:

  ```json
  {
    "success": true,
    "errors": [],
    "messages": [],
    "result": { ... } | [ ... ]
  }
  ```

- We will standardise on the following Elixir return pattern for all
  new endpoints:
  - On a `2xx` response with `success: true`:
    - Return `{:ok, result}` where `result` is:
      - A map/list decoded from the JSON body, or
      - A struct or list of structs if a struct module exists.
  - On `2xx` with `success: false` (if present in some endpoints):
    - Return `{:error, errors}` where `errors` is the list from the body.
  - On non‑`2xx` responses that still include an `errors` list:
    - Return `{:error, errors}`.
  - On any other failure (network errors, unexpected shapes):
    - Return `{:error, err}` where `err` is the original tuple or env.

- This matches the behaviour of `CloudflareApi.Zones.list/2` and
  `CloudflareApi.DnsRecords.list/create/update/delete`.

### 4.2. Struct Mapping

- For a small core set of resources (DNS Records, Zones, possibly Accounts,
  Firewall Rules, Workers routes, etc.), consider dedicated struct modules
  that:
  - Mirror the OpenAPI schema fields.
  - Implement `t()` typespecs and `from_cf_json/1`, `to_cf_json/1`.
- For less frequently used or highly nested resources, prefer returning the
  raw map as given by Cloudflare to avoid over‑abstraction.
- Document clearly in `@doc` which endpoints return structs vs raw maps.

### 4.3. Special‑Case Error Codes

- Some existing functions interpret specific Cloudflare error codes specially
  (e.g. `81057` → `:already_exists`, `81044` → `:already_deleted`).
- As we expand coverage:
  - Identify similar cases from the OpenAPI components or endpoint
    descriptions.
  - Introduce special handling **only** where it significantly improves caller
    ergonomics and is clearly documented (e.g. idempotent semantics).
  - Keep the default behaviour for other endpoints as the general
    `{:error, errors}` tuple.

---

## 5. Testing Strategy (Spec‑Driven)

### 5.1. General Principles

- All new endpoints must have tests that:
  - Exercise the happy path with realistic response bodies that obey the
    OpenAPI schema.
  - Exercise at least one failure mode per operation:
    - Validation / 4XX style errors with `errors` list.
    - Network or adapter errors where applicable.
- Tests must be **offline and deterministic**:
  - Use `Tesla.Mock` to stub responses.
  - Never hit the real Cloudflare API.
  - Never require real API tokens.

### 5.2. Using the OpenAPI Spec for Mocks

- Introduce a test‑only helper module (e.g. `CloudflareApi.TestSupport.OpenApi`)
  that can:
  - Given path + method (or `operationId`), look up the associated response
    schema(s).
  - Generate a minimal, valid example map for a schema:
    - Use `example` / `default` fields from the spec when present.
    - For objects without examples, recursively build a minimal object that
      satisfies `required` keys.
    - For arrays, include at least one example element.
  - Wrap generated `result` payloads into the common Cloudflare envelope for
    use in mocks.
- The goal is **not** to fully re‑implement JSON schema generation, but to:
  - Ensure that field names and types in mocked responses actually match the
    spec.
  - Catch mismatches between implementation and schema via tests.

### 5.3. Per‑Module Test Organisation

- For each new public module (e.g. `CloudflareApi.Accounts`), create a
  corresponding `test/cloudflare_api/accounts_test.exs` with:
  - `describe` blocks per function/operation group (e.g. `"list_accounts/2"`,
    `"get_account/2"`, `"update_account/3"`).
  - Tests for:
    - URL construction (path interpolation and query encoding).
    - Request body shape for write operations.
    - Response decoding to maps or structs.
    - Error handling (`{:error, errors}` and `{:error, err}`).
- Reuse patterns from:
  - `CloudflareApi.DnsRecordsTest`
  - `CloudflareApi.ZonesTest`
  - `CloudflareApi.UtilsTest`

### 5.4. Coverage Strategy

- Given the large number of operations, start with a **representative set per
  module**:
  - At least one list/collection endpoint.
  - At least one single‑resource GET.
  - At least one create/update/delete where applicable.
  - Any endpoints with unusual parameter or response shapes (batch operations,
    polymorphic results, etc.).
- Over time, expand to full per‑operation coverage by:
  - Adding tests for additional operations in the same module following the
    established patterns.
  - Using helpers like `CloudflareApi.TestSupport.OpenApi` to reduce
    boilerplate.

---

## 6. Documentation (HexDocs)

### 6.1. Moduledocs

- Every new module must define an `@moduledoc` that:
  - Explains what set of Cloudflare endpoints it wraps.
  - Links to the relevant sections of the official Cloudflare API docs.
  - Describes expected client usage patterns (passing `Tesla.Client` or
    a client function).
  - Notes any special behaviours (e.g. idempotent helpers, special error
    codes).
- Follow the style of:
  - `CloudflareApi.DnsRecords`
  - `CloudflareApi.Zones`
  - Root `CloudflareApi` moduledoc and README.

### 6.2. Function Docs

- Each public function wrapping an endpoint must have an `@doc` that includes:
  - A short description (summary from OpenAPI).
  - The underlying HTTP method and path (e.g. ``GET /accounts``).
  - Argument descriptions:
    - Path params (what they identify, examples).
    - Query/filter options (`opts` keyword list and the most important keys).
    - Body map/struct fields for write operations.
  - Return value contract:
    - Explicit examples of the `{:ok, ...}` and `{:error, ...}` tuples.
  - Where helpful, 1–2 short `iex>` examples for common use cases.
- Prefer concise but informative docs; avoid duplicating the entire spec, but
  provide enough context for HexDocs users to rely on the wrapper alone.

### 6.3. Cross‑Referencing

- Use intra‑docs references where appropriate:
  - Link from resource modules to their struct modules (e.g.
    `CloudflareApi.DnsRecord`).
  - Cross‑link related modules (e.g. Zones ↔ DNS Records).
- Ensure that the `mix docs` output includes all new modules and that they
  appear in the HexDocs sidebar under a sensible grouping.

---

## 7. Caching Considerations (Non‑Goals for Implementation)

- **Do not add any caching behaviour** to the new endpoint modules:
  - No automatic memoisation of GET responses.
  - No pre‑population of `CloudflareApi.Cache` from generic endpoints.
  - No background refresh or TTL logic.
- Keep caching as an **opt‑in**, explicit concern:
  - Callers that wish to cache responses can do so using existing cache
    primitives or external libraries.
- A separate document `CACHING_POSSIBILITIES.md` (see below) will enumerate
  endpoints and provide recommendations on which are good candidates for
  caching, but the code for these endpoints remains cache‑free.

---

## 8. Incremental Rollout Plan

Because the OpenAPI schema covers a large surface, implementation will proceed
incrementally, module by module.

Proposed order:

1. **Accounts & Zones**
   - Build out `CloudflareApi.Accounts` alongside existing `Zones`.
   - Ensure robust tests and docs; validate patterns for list/detail/write
     endpoints.
2. **DNS & DNS‑Adjacent Resources**
   - Extend `CloudflareApi.DnsRecords` and related modules to cover additional
     DNS endpoints from the spec.
3. **Core Infrastructure & Security**
   - Firewall Rules, Access, WAF, Page Rules, etc., each under their own
     tagged module.
4. **Workers / KV / Durable Objects / Queues**
   - Focus on serverless and storage APIs.
5. **Analytics / Logs / Monitoring**
   - Read‑heavy endpoints, potentially good caching candidates (documented in
     `CACHING_POSSIBILITIES.md` but not implemented with caching here).

For each module added:

- Implement the chosen subset of operations (eventually all operations for that
  tag).
- Add corresponding tests using `Tesla.Mock` and OpenAPI‑driven response
  generation.
- Write moduledoc and function docs.
- Update `CHANGELOG.md` with a brief note describing the new coverage.

---

## 9. Validation & Tooling

- After implementing each batch of endpoints:
  - Run `mix test` (or `mix test test/cloudflare_api/<module>_test.exs` for
    focused checks).
  - Run `mix format` and `mix credo` to stay aligned with the existing style.
  - Optionally run `MIX_ENV=dev mix dialyzer` once larger chunks are merged.
- Consider adding a small mix task (future work) that:
  - Compares the set of OpenAPI `operationId`s with the set of implemented
    functions.
  - Reports any missing or extra functions so we can keep “full coverage” in
    sync with spec updates.

---

## 10. Summary

- Use the vendored OpenAPI schema as the definitive contract.
- Expand the library by:
  - Creating tag‑based modules with thin wrappers around each operation.
  - Reusing the existing client, error handling, and testing patterns.
  - Driving mocks and response validation from the schema to keep tests
    accurate.
  - Keeping caching concerns out of the new endpoints while separately
    documenting where caching might be beneficial.
- Ensure that every new module and function is well documented so that the
  expanded API surface is approachable from HexDocs and `h`/`i` helpers in IEx.
