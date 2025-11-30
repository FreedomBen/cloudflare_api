defmodule CloudflareApi do
  @moduledoc ~S"""
  Top-level entry point for the Cloudflare API client.

  `CloudflareApi` is a thin, explicit wrapper around the
  [Cloudflare v4 API](https://api.cloudflare.com/). It provides convenient
  functions and Elixir idioms so you don't have to work with raw HTTP
  requests by hand.

  ## Status

  _Note:_ this package is under active development and may be refactored in
  substantive ways. If you need to get to production quickly, consider
  pinning to a specific version and watching the changelog.

  ## Philosophy

  This library assumes that a well-designed REST API does not need a heavy
  abstraction layer on top:

  - Request/response shapes stay close to the official Cloudflare JSON.
  - Functions generally return `{:ok, result}` / `{:error, reason}` tuples.
  - Modules and function names mirror Cloudflare's own endpoint groupings.

  The upside is that you can keep the official Cloudflare documentation open
  alongside this library instead of learning a separate abstraction. The
  downside is that if you *want* to be fully shielded from the underlying API
  details, this probably is not the package for you.

  ## Getting started

  The usual way to use the library is:

      token  = System.fetch_env!("CLOUDFLARE_API_TOKEN")
      client = CloudflareApi.new(token)

      {:ok, zones} = CloudflareApi.Zones.list(client)

  or, using the zero-arity client function:

      client_fun = CloudflareApi.client("api-token")
      {:ok, records} = CloudflareApi.DnsRecords.list(client_fun, "zone-id", name: "www.example.com")

  You may also wish to look through the Livebooks in `livebooks/` for
  additional end-to-end examples.
  """

  use CloudflareApi.Typespecs

  @typedoc "A configured Tesla client or a zero-arity function that returns one."
  @type client :: Tesla.Client.t() | (-> Tesla.Client.t())

  @typedoc "Common keyword or map options passed to Cloudflare endpoints."
  @type options :: keyword() | map() | nil

  @typedoc "Standard error reasons returned by this library when wrapping HTTP calls."
  @type error_reason :: Tesla.Env.t() | Tesla.Error.t() | term()

  @typedoc "Helper type for `{:ok, value}` / `{:error, reason}` tuples."
  @type result(result) :: {:ok, result} | {:error, error_reason()}

  @typedoc "Generic identifier helper for Cloudflare resource IDs."
  @type id :: String.t()

  @doc ~S"""
  Build a `Tesla.Client.t()` configured for the Cloudflare v4 API.

  The returned client can be passed to any of the `CloudflareApi.*` endpoint
  modules.

  - `cloudflare_api_token` – a Cloudflare API token with the permissions your
    calls require

  ## Examples

      iex> client = CloudflareApi.new("api-token")
      iex> is_struct(client, Tesla.Client)
      true

  """
  def new(cloudflare_api_token) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, "https://api.cloudflare.com/client/v4"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: cloudflare_api_token}
    ])
  end

  @doc ~S"""
  Build a reusable zero-arity client function.

  This wraps `new/1` and returns a function that, when called, yields a
  configured `Tesla.Client.t()`. It is convenient when you want to inject a
  "current Cloudflare client" into other modules without threading the
  `%Tesla.Client{}` struct manually.

  - `cloudflare_api_token` – a Cloudflare API token with the permissions your
    calls require

  ## Examples

      iex> client_fun = CloudflareApi.client("api-token")
      iex> client1 = client_fun.()
      iex> client2 = client_fun.()
      iex> is_struct(client1, Tesla.Client) and client1 == client2
      true

  """
  def client(cloudflare_api_token) do
    c = CloudflareApi.new(cloudflare_api_token)
    fn -> c end
  end

  @doc false
  def uri_encode_opts(opts) do
    URI.encode_query(opts, :rfc3986)
  end
end
