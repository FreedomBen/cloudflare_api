defmodule CloudflareApi.CertificatePacks do
  @moduledoc ~S"""
  Manage SSL certificate packs for a zone.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.list(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(zone_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Order certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.order(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def order(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/order", params)
    |> handle_response()
  end

  @doc ~S"""
  Quota certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.quota(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def quota(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/quota")
    |> handle_response()
  end

  @doc ~S"""
  Get certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.get(client, "zone_id", "pack_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, pack_id) do
    c(client)
    |> Tesla.get(pack_path(zone_id, pack_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.delete(client, "zone_id", "pack_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, pack_id) do
    c(client)
    |> Tesla.delete(pack_path(zone_id, pack_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Restart validation for certificate packs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CertificatePacks.restart_validation(client, "zone_id", "pack_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def restart_validation(client, zone_id, pack_id, params \\ %{}) when is_map(params) do
    c(client)
    |> Tesla.patch(pack_path(zone_id, pack_id), params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/ssl/certificate_packs"
  defp pack_path(zone_id, pack_id), do: base_path(zone_id) <> "/#{pack_id}"

  defp list_url(zone_id, []), do: base_path(zone_id)

  defp list_url(zone_id, opts),
    do: base_path(zone_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
