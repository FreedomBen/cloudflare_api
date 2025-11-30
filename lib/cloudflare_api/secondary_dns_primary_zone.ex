defmodule CloudflareApi.SecondaryDnsPrimaryZone do
  @moduledoc ~S"""
  Manage secondary DNS primary zone (outgoing) configurations under `/zones/:zone_id/secondary_dns/outgoing`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Get secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.get(client, "zone_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, opts \\ []) do
    fetch(client, base_path(zone_id), opts)
  end

  @doc ~S"""
  Create secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.update(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.delete(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id) do
    c(client)
    |> Tesla.delete(base_path(zone_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Disable transfers for secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.disable_transfers(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def disable_transfers(client, zone_id) do
    post_action(client, zone_id, "disable")
  end

  @doc ~S"""
  Enable transfers for secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.enable_transfers(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def enable_transfers(client, zone_id) do
    post_action(client, zone_id, "enable")
  end

  @doc ~S"""
  Force notify for secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.force_notify(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def force_notify(client, zone_id) do
    post_action(client, zone_id, "force_notify")
  end

  @doc ~S"""
  Status secondary dns primary zone.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.SecondaryDnsPrimaryZone.status(client, "zone_id", [])
      {:ok, %{"id" => "example"}}

  """

  def status(client, zone_id, opts \\ []) do
    fetch(client, base_path(zone_id) <> "/status", opts)
  end

  defp post_action(client_or_fun, zone_id, action) do
    c(client_or_fun)
    |> Tesla.post(base_path(zone_id) <> "/#{action}", %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/secondary_dns/outgoing"

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

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
