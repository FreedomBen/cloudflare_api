# Cloudflare OpenAPI Sync Plan

This document tracks the plan for reconciling the current `cloudflare_api`
implementation with the official Cloudflare OpenAPI schema at
`priv/cloudflare_api/openapi.json`, without adding any new endpoints.

It focuses specifically on the existing Zones and DNS Records helpers. For a
broader plan to implement wrappers for all OpenAPI operations, see
`FULL_API_IMPLEMENTATION_PLAN.md`. For future, opt-in caching ideas, see
`CACHING_POSSIBILITIES.md`.

## Scope

- Endpoints under `/zones` used by `CloudflareApi.Zones.list/2`.
- Endpoints under `/zones/{zone_id}/dns_records` used by
  `CloudflareApi.DnsRecords`:
  - `list/3`
  - `list_for_hostname/4`
  - `list_for_host_domain/5`
  - `create/3`
  - `create/4`
  - `update/5`
  - `delete/3`

## Known Mismatches / Gaps

- `CloudflareApi.DnsRecords.list_for_hostname/4` ignores the supplied `type`
  argument and always uses `"A"` in the query string, which does not match the
  OpenAPI `dns-records_type` enum semantics.
- We do not currently have tests that assert we correctly encode the main
  query parameters defined in the spec for:
  - `/zones/{zone_id}/dns_records` (e.g. `name`, `type`, `content`, `page`,
    `per_page`, `order`, `direction`, tag-related filters, etc.).
  - `/zones` (e.g. `name`, `status`, `account.id`, `account.name`, `page`,
    `per_page`, `order`, `direction`, `match`).
- `CloudflareApi.DnsRecord` type specs are slightly confusing compared to the
  OpenAPI schema (record types are defined in `dns-records_type` but are
  currently aliased via a `ttl` type), which makes it harder to see that the
  struct mirrors the spec.
- The delete DNS record endpoint in the OpenAPI spec shows a required (but
  empty) JSON request body, while `CloudflareApi.DnsRecords.delete/3` currently
  issues a bare `DELETE` without a body. This is probably accepted by the
  live API, but it is a small divergence from the schema.

## Planned Code Adjustments

1. **Fix `list_for_hostname/4` type handling**
   - Update `CloudflareApi.DnsRecords.list_for_hostname/4` to pass the
     supplied `type` argument through to `list/3` instead of hard-coding `"A"`.
   - Keep the default `nil` behaviour as “no `type` filter” to match the
     OpenAPI definition where `type` is optional.

2. **Clarify DNS record type specs**
   - Adjust `CloudflareApi.DnsRecord` types so that:
     - The record-type enum is clearly named (e.g. `@type record_type`) and
       matches the values from `dns-records_type` in the schema.
     - The `type` field in the struct is typed against that enum while still
       interoperating with strings returned by Cloudflare.
   - Ensure `to_cf_json/1` and `from_cf_json/1` continue to map cleanly to the
     OpenAPI-defined fields (`name`, `content`, `ttl`, `proxied`, etc.).

3. **Evaluate `DELETE` request body alignment**
   - Confirm (via docs/spec only, no live calls) whether the required empty
     JSON body on `DELETE /zones/{zone_id}/dns_records/{dns_record_id}` is
     purely a schema artifact or required in practice.
   - If we decide to strictly follow the spec, update
     `CloudflareApi.DnsRecords.delete/3` to send an empty JSON body (`%{}`) and
     adjust tests to assert on this.
   - If sending an empty body is not necessary or could cause compatibility
     issues, document the divergence here and keep the current behaviour.

4. **(Optional) TTL guardrails**
   - The spec constrains `ttl` to either `1` (automatic) or a range between
     60 and 86400 seconds (30 min for Enterprise minimum 30).
   - Decide whether this library should:
     - Enforce these bounds in `create/3`, `create/4`, and `update/5`
       (returning `{:error, :invalid_ttl}` or similar), or
     - Continue to pass values through to the API and rely on Cloudflare’s
       own validation.
   - If enforcing locally, add minimal, clear guards only where we build the
     payload, and keep the change backward-compatible where possible.

## Planned Test Additions / Updates

1. **DNS Records query parameter coverage**
   - Extend `CloudflareApi.DnsRecordsTest` to cover:
     - `list_for_hostname/4` with a non-`"A"` type (e.g. `"AAAA"`) and assert
       that the generated URL contains `type=AAAA` as per the OpenAPI enum.
     - `list/3` with representative query options from the spec:
       - Simple filters (`name`, `type`, `content`).
       - At least one dotted key (e.g. `"name.exact"`, `"comment.contains"`,
         `"tag.contains"`) to ensure `uri_encode_opts/1` handles them as
         expected.
       - Pagination and ordering (`page`, `per_page`, `order`, `direction`).

2. **Zones query parameter coverage**
   - Extend `CloudflareApi.ZonesTest` to verify that:
     - `Zones.list/2` properly encodes the main OpenAPI parameters:
       `name`, `status`, `account.id`, `account.name`, `page`, `per_page`,
       `order`, `direction`, and `match`.
     - The generated URLs match the expected query strings (using Tesla.Mock).

3. **DNS record type and TTL behaviour**
   - Add tests around `CloudflareApi.DnsRecord`:
     - Ensure the struct and `from_cf_json/1` accept values for `type` that
       are in the OpenAPI enum (`A`, `AAAA`, etc.).
     - If we add local TTL validation, test both accepted and rejected values
       to mirror the ranges documented in the OpenAPI schema.

4. **Delete endpoint behaviour**
   - Update `CloudflareApi.DnsRecordsTest` for `delete/3`:
     - If we start sending an empty body, assert that the mocked `DELETE`
       request includes the expected JSON body.
     - Keep existing coverage for the success path (returns `{:ok, id}`) and
       the “already deleted” special case (error code `81044`), which are
       consistent with the failure schema in the spec.

## Validation

- Run `mix test` to ensure all existing and new tests pass.
- Optionally run `mix format --check-formatted` to verify formatting.
- Keep this file updated if we discover additional spec mismatches while
  working through the changes above.
