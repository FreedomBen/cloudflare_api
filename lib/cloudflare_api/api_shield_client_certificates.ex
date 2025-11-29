defmodule CloudflareApi.ApiShieldClientCertificates do
  @moduledoc ~S"""
  Manage API Shield client certificates and hostname associations for a zone.
  """

  @doc ~S"""
  List certificates for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.list_certificates(client, "zone_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_certificates(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(zone_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create certificate for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.create_certificate(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_certificate(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(certificates_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get certificate for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.get_certificate(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def get_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.get(certificate_path(zone_id, certificate_id))
    |> handle_response()
  end

  @doc ~S"""
  Update certificate for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.update_certificate(client, "zone_id", "certificate_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_certificate(client, zone_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(certificate_path(zone_id, certificate_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete certificate for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.delete_certificate(client, "zone_id", "certificate_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.delete(certificate_path(zone_id, certificate_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List hostname associations for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.list_hostname_associations(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_hostname_associations(client, zone_id) do
    c(client)
    |> Tesla.get(hostname_assoc_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update hostname associations for api shield client certificates.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ApiShieldClientCertificates.update_hostname_associations(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_hostname_associations(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(hostname_assoc_path(zone_id), params)
    |> handle_response()
  end

  defp list_url(zone_id, []), do: certificates_path(zone_id)

  defp list_url(zone_id, opts) do
    certificates_path(zone_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp certificates_path(zone_id), do: "/zones/#{zone_id}/client_certificates"

  defp certificate_path(zone_id, certificate_id),
    do: certificates_path(zone_id) <> "/#{certificate_id}"

  defp hostname_assoc_path(zone_id),
    do: "/zones/#{zone_id}/certificate_authorities/hostname_associations"

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
