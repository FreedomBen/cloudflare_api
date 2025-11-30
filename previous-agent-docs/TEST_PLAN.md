# Test Plan for `cloudflare_api`

This plan describes how to exercise all functionality without hitting the real Cloudflare API. All tests should run offline and deterministically.

## General Testing Approach

- Use ExUnit for all tests.
- Use a mock or custom Tesla adapter (e.g., `Tesla.Mock`) to stub HTTP responses for `CloudflareApi.DnsRecords` and `CloudflareApi.Zones`.
- Avoid real API tokens or network I/O; tests must pass with no external configuration.
- Prefer unit tests over integration tests; focus on module-level behavior and return values.

## CloudflareApi (root module)

- `new/1`:
  - Returns a `Tesla.Client` with base URL `https://api.cloudflare.com/client/v4`.
  - Includes JSON middleware and bearer auth with the provided token (inspect `client.pre`).
- `client/1`:
  - Returns a zero-arity function.
  - Multiple invocations of the function return the same `Tesla.Client` instance.
- `uri_encode_opts/1`:
  - Encodes keyword lists and maps according to RFC3986 (spaces, special characters, etc.).

## DNS Records (`CloudflareApi.DnsRecords`)

Use `Tesla.Mock` to return controlled `%Tesla.Env{}` values.

- `list/3`:
  - 200 success with `result` list → `{:ok, [%DnsRecord{}...]}`.
  - 4xx/5xx with `%{"errors" => [...]}` → `{:error, errors}`.
  - Non-matching shapes (e.g., network error tuple) → `{:error, err}`.
- `list_for_hostname/4` and `list_for_host_domain/5`:
  - Verify hostname construction and that `list/3` is called with expected opts (via mock assertion).
  - Cases: `type` nil vs `"A"`, host already including domain vs host needing concatenation.
- `create/3` and `create/4`:
  - 200 success → `{:ok, %DnsRecord{}}` with fields mapped from `result`.
  - 400 with code `81057` → `{:ok, :already_exists}` / `{:ok, :already_created}`.
  - Other error bodies → `{:error, errors}`.
- `update/5`:
  - 200 success mapping into `DnsRecord`.
  - Error body with `errors` → `{:error, errors}`.
- `delete/3`:
  - 200 success → `{:ok, id}` from `result["id"]`.
  - 404 with code `81044` → `{:ok, :already_deleted}`.
  - Other error bodies → `{:error, errors}`.
- `hostname_exists?/4`, `host_domain_exists?/5`:
  - When `list_*` returns `{:ok, []}` → `false`.
  - When `{:ok, [record...]}` → `true`.
  - Document current behavior that `{:error, ...}` will raise (pattern match) and test that raising behavior explicitly.

## Zones (`CloudflareApi.Zones`)

- `list/2` (with mocked Tesla):
  - 200 success → `{:ok, zones_list}` where `zones_list == body["result"]`.
  - Error bodies with `errors` → `{:error, errors}`.
  - Network/other failures → `{:error, err}`.
  - `opts` nil vs non-nil: confirm proper query string via `uri_encode_opts/1`.

## Cache (`CloudflareApi.Cache` and `CacheEntry`)

Use `start_supervised!({CloudflareApi.Cache, []})` in tests.

- `add_or_update/1` and `/2`:
  - Adds new entries keyed by hostname; returns the `DnsRecord`.
  - Updating same hostname overwrites previous entry.
- `includes?/1`:
  - `false` for missing hostname, `true` after add.
- `get/1` and `get/2`:
  - Returns `DnsRecord` for present, non-expired entries.
  - Returns `nil` via `get_entry` when expired (simulate by manipulating timestamps via `CacheEntry` or helper).
- `delete/1`, `flush/0`, `dump/0`, `dump_cache/0`:
  - Deleting removes only one hostname.
  - `flush/0` clears all entries and resets struct.
  - `dump/0` returns just records; `dump_cache/0` returns full internal state with hostnames map.
- Expiration logic:
  - Configure short `expire_seconds` in initial state (via custom `start_link` args or direct `handle_call` tests) to verify entries expire based on `timestamp`.

## Data Structures (`DnsRecord`, `Zone`, `CacheEntry`)

- `DnsRecord`:
  - `to_cf_json/1` maps struct fields to Cloudflare JSON fields.
  - `from_cf_json/1` handles both string-keyed and struct-like maps; verify type, TTL, and flags.
- `Zone`:
  - `to_cf_json/1` delegates to `Utils.struct_to_map/1`.
  - `from_cf_json/1` with string and atom keys.
- `CacheEntry`:
  - Enforces required keys; type correctness for `timestamp` and `dns_record`.

## Utils Modules

Focus on pure functions and edge cases; use doctest-like examples.

- `CloudflareApi.Utils`:
  - `inspect_format/2`, `inspect/3`: verify options and string output contain key fields.
  - Map/list/tuple stringification and masking (`map_to_string/2`, `list_to_string/2`, `tuple_to_string/2`, `to_string/2`, `mask_map_key_values/2`, `mask_str/1`).
  - `nil_or_empty?/1`, `not_nil_or_empty?/1`, `raise_if_nil!/1,2`.
  - `explicitly_true?/1`, `explicitly_false?/1`, `false_or_explicitly_true?/1`, `true_or_explicitly_false?/1` with various inputs.
- `CloudflareApi.Utils.Enum.none?/2`:
  - Cases where all predicates false vs some true.
- `CloudflareApi.Utils.Crypto`:
  - `strong_random_string/1`: correct length and allowed character set (non-deterministic, so assert shape only).
  - `hash_token/1`: deterministic output for same input.
- `CloudflareApi.Utils.DateTime`:
  - `utc_now_trunc/0` second precision.
  - `adjust_cur_time*/2`, `adjust_time/3`, `in_the_past?/1,2`, `expired?/1,2` using fixed DateTime values.
- `CloudflareApi.Utils.IPv4.to_s/1`:
  - Tuple conversion to dotted string.
- `CloudflareApi.Utils.FromEnv`:
  - Given fake `%Macro.Env{}` structs, assert `log_str/1`, `mfa_str/1`, etc. formatting.
- `CloudflareApi.Utils.Logger` and `LoggerColor`:
  - Use `ExUnit.CaptureLog` to assert log level and ANSI color metadata for each wrapper.

## Application Behaviour

- `CloudflareApi.Application.start/2`:
  - Using `start_supervised!`, ensure the application supervisor starts `CloudflareApi.Cache`.
  - Confirm the registered name `:cloudflare_api_cache` is alive and responds to GenServer calls.

## Non-Goals / Out of Scope

- No real HTTP calls to `api.cloudflare.com`.
- No tests relying on real API tokens, zones, or DNS records.
- No coverage of Livebook notebooks; they are treated as manual examples only.

