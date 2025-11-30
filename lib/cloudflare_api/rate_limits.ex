defmodule CloudflareApi.RateLimits do
  @moduledoc ~S"""
  Manage zone-level rate limits (`/zones/:zone_id/rate_limits`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List rate limits.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RateLimits.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create rate limits.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RateLimits.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get rate limits.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RateLimits.get(client, "zone_id", "rate_limit_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, rate_limit_id) do
    c(client)
    |> Tesla.get(rule_path(zone_id, rate_limit_id))
    |> handle_response()
  end

  @doc ~S"""
  Update rate limits.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RateLimits.update(client, "zone_id", "rate_limit_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, rate_limit_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(zone_id, rate_limit_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete rate limits.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RateLimits.delete(client, "zone_id", "rate_limit_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, rate_limit_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, rate_limit_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/rate_limits"
  defp rule_path(zone_id, rate_limit_id), do: base_path(zone_id) <> "/#{rate_limit_id}"

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
