defmodule CloudflareApi.ZoneCacheSettings do
  @moduledoc ~S"""
  Manage cache reserve, cache reserve clear, regional tiered cache, and cache
  variants for a zone.
  """

  ## Cache Reserve

  @doc ~S"""
  Get cache reserve for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.get_cache_reserve(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_cache_reserve(client, zone_id) do
    c(client)
    |> Tesla.get(cache_reserve_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch cache reserve for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.patch_cache_reserve(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_cache_reserve(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(cache_reserve_path(zone_id), params)
    |> handle_response()
  end

  ## Cache Reserve Clear

  @doc ~S"""
  Get cache reserve clear for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.get_cache_reserve_clear(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_cache_reserve_clear(client, zone_id) do
    c(client)
    |> Tesla.get(cache_reserve_clear_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Start cache reserve clear for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.start_cache_reserve_clear(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def start_cache_reserve_clear(client, zone_id, params \\ %{}) do
    c(client)
    |> Tesla.post(cache_reserve_clear_path(zone_id), params)
    |> handle_response()
  end

  ## Regional Tiered Cache

  @doc ~S"""
  Get regional tiered cache for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.get_regional_tiered_cache(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_regional_tiered_cache(client, zone_id) do
    c(client)
    |> Tesla.get(regional_tiered_cache_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch regional tiered cache for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.patch_regional_tiered_cache(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_regional_tiered_cache(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(regional_tiered_cache_path(zone_id), params)
    |> handle_response()
  end

  ## Variants

  @doc ~S"""
  Get variants for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.get_variants(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_variants(client, zone_id) do
    c(client)
    |> Tesla.get(variants_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch variants for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.patch_variants(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_variants(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(variants_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete variants for zone cache settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneCacheSettings.delete_variants(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_variants(client, zone_id) do
    c(client)
    |> Tesla.delete(variants_path(zone_id), body: %{})
    |> handle_response()
  end

  defp cache_reserve_path(zone_id), do: "/zones/#{zone_id}/cache/cache_reserve"
  defp cache_reserve_clear_path(zone_id), do: "/zones/#{zone_id}/cache/cache_reserve_clear"
  defp regional_tiered_cache_path(zone_id), do: "/zones/#{zone_id}/cache/regional_tiered_cache"
  defp variants_path(zone_id), do: "/zones/#{zone_id}/cache/variants"

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
