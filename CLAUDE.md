# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Elixir library that provides a thin wrapper around the Cloudflare API. It's designed to offer convenient functions and Elixir idioms without heavy abstraction layers, allowing developers to work directly with the well-documented Cloudflare API.

## Development Commands

### Core Development Workflow
```bash
# Setup and compile
mix deps.get
mix compile

# Run tests
mix test
mix test test/cloudflare_api_test.exs          # Run specific test file
mix test test/cloudflare_api/cache_test.ex     # Run specific test file

# Code quality checks
mix format                                     # Format code
mix format --check-formatted                   # Check formatting
mix credo                                     # Static code analysis
mix dialyzer                                  # Type checking

# Generate documentation
mix docs

# Interactive development
iex -S mix
```

### Additional Useful Commands
```bash
# Dependency management
mix deps.update                               # Update dependencies
mix deps.tree                                # Show dependency tree

# Build and release
mix release                                  # Create release build
```

## Architecture

The library follows a modular structure organized around Cloudflare API endpoints:

- **CloudflareApi** - Main module with client creation functions (`new/1`, `client/1`)
- **CloudflareApi.DnsRecords** - DNS record operations (list, create, update, delete)
- **CloudflareApi.Zones** - Zone management operations
- **CloudflareApi.DnsRecord** - DNS record data structure and JSON conversion
- **CloudflareApi.Zone** - Zone data structure
- **CloudflareApi.Cache** - Caching functionality with expiration support
- **CloudflareApi.Utils** - Utility modules for common operations

### Key Design Patterns

1. **Client Pattern**: All API operations accept a Tesla client or client function as the first parameter
2. **Thin Wrapper Philosophy**: Functions map closely to Cloudflare API endpoints without heavy abstraction
3. **Elixir Idioms**: Returns `{:ok, result}` or `{:error, reason}` tuples
4. **Options Support**: Query parameters passed as Keyword lists (e.g., `name: hostname, type: "A"`)

### Dependencies

- **Tesla** - HTTP client library
- **Jason** - JSON encoding/decoding
- **Hackney** - HTTP adapter for Tesla
- **Credo** - Static code analysis (dev/test)
- **Dialyxir** - Type checking (dev)
- **ExDoc** - Documentation generation

## Testing

The project uses ExUnit for testing. Tests are organized in:
- `test/cloudflare_api_test.exs` - Main module tests
- `test/cloudflare_api/` - Individual module tests

Test helper is configured in `test/test_helper.exs`.

## Documentation

The project uses ExDoc for generating documentation. The main documentation entry point is the `CloudflareApi` module. API documentation is not auto-generated to encourage developers to refer to the official Cloudflare API documentation.

## Version and Packaging

Current version: 0.2.3
Package name: `cloudflare_api`
Source: https://github.com/freedomben/cloudflare_api

## Notes for Development

- The library is still under active development and may undergo substantive refactoring
- New endpoints should follow the existing pattern of thin wrappers around Cloudflare API calls
- Error handling should return `{:error, errors}` tuples where errors come from the Cloudflare API response
- Special cases like "already exists" or "already deleted" return success tuples like `{:ok, :already_exists}`