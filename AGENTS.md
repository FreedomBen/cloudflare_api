# Repository Guidelines

This document is a concise contributor guide for the `cloudflare_api` Elixir library.

## Agent instructions
- Write comprehensive tests for any changed or added functionality.  Tests should exercise both happy path and also test for incorrect or invalid input.
- Update the CHANGELOG.md when making changes


## Project Structure & Modules

- `lib/` – main source code. Core modules live under `lib/cloudflare_api/` (e.g., `dns_records.ex`, `zones.ex`, `cache.ex`).
- `test/` – ExUnit tests (`cloudflare_api_test.exs` and module‑specific tests under `test/cloudflare_api/`).
- `doc/` – generated ExDoc output; do not edit by hand.
- `livebooks/` – exploratory Livebook notebooks; useful for examples, not for automated tests.
- `_build/`, `deps/` – Mix build artifacts and dependencies; never commit manual changes here.

## Build, Test, and Development Commands

- `mix deps.get` – install/update dependencies.
- `mix compile` – compile the project.
- `mix test` – run the full ExUnit test suite (use `mix test path/to/file_test.exs` for a single file).
- `mix format` / `mix format --check-formatted` – format code and verify formatting.
- `mix credo` – run static analysis; `mix dialyzer` – run dialyzer checks.
- `mix docs` – generate documentation; `iex -S mix` – interactive shell for local experiments.

## Coding Style & Naming Conventions

- Use `mix format` as the source of truth (2‑space indentation, no tabs).
- Modules use `CamelCase` (e.g., `CloudflareApi.DnsRecords`); functions, variables, and files use `snake_case`.
- Keep new modules thin wrappers around Cloudflare endpoints, returning `{:ok, value}` / `{:error, reason}` tuples.
- Place new endpoint modules under `lib/cloudflare_api/` and mirror existing naming (e.g., `DnsRecords`, `Zones`).

## Testing Guidelines

- Use ExUnit with `_test.exs` files under `test/` and `describe` blocks per function or behavior.
- Add or update tests for any new behavior and ensure `mix test` passes before opening a pull request.
- Prefer fast, deterministic tests; avoid real Cloudflare network calls in unit tests (mock or isolate HTTP when needed).

## Commit & Pull Request Guidelines

- Use short, descriptive commit messages similar to the existing history (e.g., `Fix automatic TTL in DNS record`, `Bump version to 0.2.3`).
- Each pull request should include a brief summary, motivation, and notes on breaking changes.
- Link related issues when applicable and mention any docs or tests that were added or adjusted.

## Security & Configuration Tips

- Never commit real API tokens or secrets. Use environment variables (e.g., `CLOUDFLARE_API_TOKEN`) or local config for credentials.
- When adding examples, use clearly fake tokens and hostnames and keep them out of the main library code.

