defmodule CloudflareApi.ZoneAccessMtlsAuthentication do
  @moduledoc ~S"""
  Manage zone-level Access mTLS certificates and hostname settings.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List certificates for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.list_certificates(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_certificates(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create certificate for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.create_certificate(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_certificate(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get certificate for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.get_certificate(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def get_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.get(cert_path(zone_id, certificate_id))
    |> handle_response()
  end

  @doc ~S"""
  Update certificate for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.update_certificate(client, "zone_id", "certificate_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_certificate(client, zone_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(cert_path(zone_id, certificate_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete certificate for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.delete_certificate(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.delete(cert_path(zone_id, certificate_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Get settings for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.get_settings(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_settings(client, zone_id) do
    c(client)
    |> Tesla.get(settings_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update settings for zone access mtls authentication.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessMtlsAuthentication.update_settings(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id), params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/access/certificates"
  defp cert_path(zone_id, certificate_id), do: base_path(zone_id) <> "/#{certificate_id}"
  defp settings_path(zone_id), do: base_path(zone_id) <> "/settings"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
