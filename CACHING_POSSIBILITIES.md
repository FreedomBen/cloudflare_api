# Caching Possibilities for Cloudflare Endpoints

This document lists high‑level caching recommendations for the Cloudflare
Client API v4 endpoints described in `priv/cloudflare_api/openapi.json`.

The intent is **advisory only**:

- The implementation plan for new endpoints does **not** add any caching.
- These notes are here to guide future, explicit caching layers or helpers.
- The existing `CloudflareApi.Cache` module is intentionally scoped to
  DNS-related lookups; it should not be automatically wired into new endpoint
  modules without explicit, opt-in design.

## General Caching Principles

- **Safe methods vs. unsafe methods**
  - `GET` (and `HEAD`) operations are generally candidates for response
    caching, subject to data volatility and access control.
  - `POST`, `PUT`, `PATCH`, and `DELETE` usually mutate state and their
    responses should not be cached globally; at most, callers might cache some
    derived read‑only view after the fact.
- **Configuration vs. analytics**
  - Configuration resources that change infrequently (zones, DNS records,
    firewall rules, account metadata, etc.) can often be cached with moderate
    TTLs.
  - Analytics, logs, and metrics endpoints tend to be highly time‑sensitive;
    caching may only make sense for very short windows or for repeated
    identical queries.
- **Per‑caller caching**
  - Most Cloudflare endpoints are scoped to an account, user, or zone. Any
    future caching layer should respect this and avoid leaking data across
    tenants.

The sections below group endpoints by their primary OpenAPI **tag** and give a
recommendation for whether **read operations** under that tag are good
candidates for caching. Write operations under all tags are generally **not
recommended** for shared caching and are not called out individually.

> NOTE: The OpenAPI schema currently exposes a large number of tags (over 400).
> This document focuses on the most commonly used and clearly defined tag
> groups and patterns. Tags not explicitly listed here should be evaluated on
> a case‑by‑case basis using the same principles.

---

## Strong Caching Candidates (Read‑Heavy, Stable Configuration)

These tag groups typically represent configuration resources that change
infrequently and are often reused across requests.

- **Accounts**
  - Typical endpoints: list accounts, get account details.
  - Recommendation: `GET` responses can be cached with moderate TTLs (minutes
    to hours) per API token; writes should invalidate or bypass cache.
- **Zones**
  - Typical endpoints: list zones, get zone details, zone settings.
  - Recommendation: good candidates for caching zone metadata and settings.
    Invalidate relevant cache entries on zone updates.
- **DNS Records for a Zone**
  - Typical endpoints: list DNS records, get DNS record details.
  - Recommendation: strong candidate for caching, especially for read‑heavy
    tools. Cache per zone and per query filter; invalidate on DNS record
    changes.
- **User Profile / User Details**
  - Typical endpoints: get current user, user profile details.
  - Recommendation: cacheable per token with long TTL; invalidation not
    critical as changes are rare.
- **Firewall Rules / WAF Rules**
  - Typical endpoints: list rules, get rule details.
  - Recommendation: cache rule metadata with moderate TTL; invalidate on rule
    updates.
- **Page Rules / Transform Rules**
  - Recommendation: similar to firewall rules—cache configuration, invalidate
    on changes.
- **Workers Routes / Workers Scripts (metadata only)**
  - Recommendation: cache list/detail metadata for Workers with moderate TTL;
    responses are unlikely to change frequently in production.
- **KV Namespaces / Durable Objects Namespaces (metadata)**
  - Recommendation: cache namespace listings and metadata; key‑level values
    should be handled by KV itself, not this library.

---

## Moderate Caching Candidates (Configuration with Some Volatility)

These tag groups represent configuration that may change more frequently or
where incorrect staleness is more visible but still tolerable for short
periods.

- **Access Policies / Access Applications**
  - Recommendation: `GET` endpoints could be cached for short TTLs (tens of
    seconds to a few minutes), especially in dashboards or admin tooling.
- **Load Balancers / Origin Pools**
  - Recommendation: cache small, read‑heavy lists and details with short to
    moderate TTLs; stale data could affect UX but not core routing.
- **Spectrum / Argo / Smart Routing**
  - Recommendation: configuration endpoints can be cached briefly; avoid
    long‑lived caches because these services may be adjusted dynamically.
- **SSL / TLS Settings**
  - Recommendation: cacheable but with conservative TTLs, as certificate and
    mode changes have operational impact.
- **Rulesets / Policies**
  - Recommendation: cache metadata and ruleset listings with short TTLs;
    invalidation on changes is important but can be approximated by TTL.

---

## Weak Caching Candidates (Highly Dynamic or Time‑Series Data)

These tag groups generally represent data that changes rapidly or is inherently
time‑based.

- **Analytics / Metrics / Reporting**
  - Typical endpoints: zone analytics, spectrum analytics, firewall events
    summaries.
  - Recommendation: only consider very short TTLs for identical query
    parameters (seconds to a couple of minutes) to collapse bursts of
    identical requests; otherwise treat as non‑cacheable.
- **Logs / Logpull / Logpush Management**
  - Recommendation: management endpoints (list jobs, describe destinations)
    can be cached lightly; actual log data retrieval should not be cached by
    this library.
- **Billing / Usage / Audit Logs**
  - Recommendation: avoid caching or keep TTLs extremely short; correctness
    and recency generally matter more than latency here.
- **Health Checks / Monitoring / Status**
  - Recommendation: usually not cacheable beyond very small TTLs; callers
    often need current status.

---

## Generally Not Recommended for Caching

Across **all tags**, the following operation types should **not** have their
responses cached by this library:

- Resource creation (`POST`) – creates new accounts, zones, records, rules,
  etc.
- Resource updates (`PUT`, `PATCH`) – change configuration or state.
- Deletions (`DELETE`) – remove resources.
- Any operation explicitly documented as asynchronous or providing only
  transient status (e.g. task queues, async job status checks).

Callers may still choose to cache derived information for their own use (for
example, caching a freshly retrieved zone configuration in their own process),
but that is outside the scope of this library.

---

## Future Work

- Once the full set of modules and functions is implemented from the OpenAPI
  spec, we can:
  - Generate a more fine‑grained view that enumerates each `(method, path)`
    operation and applies the above rules automatically.
  - Mark endpoints where Cloudflare’s own HTTP caching headers (`Cache‑Control`,
    `ETag`, etc.) provide additional guidance.
  - Identify high‑value hotspots where optional, explicit caching helpers
    (e.g. around DNS and zone metadata) would provide meaningful performance
    wins without surprising users.
