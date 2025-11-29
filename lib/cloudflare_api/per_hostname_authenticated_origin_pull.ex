defmodule CloudflareApi.PerHostnameAuthenticatedOriginPull do
  @moduledoc ~S"""
  Manage per-hostname authenticated origin pull settings and certificates via
  `/zones/:zone_id/origin_tls_client_auth/hostnames`.
  """

  @doc ~S"""
  Enable/disable hostnames for authenticated origin pulls (`PUT /hostnames`).
  """
  def set_hostnames(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get a hostname's client authentication status (`GET /hostnames/:hostname`).
  """
  def get_hostname(client, zone_id, hostname) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/#{encode(hostname)}")
    |> handle_response()
  end

  @doc ~S"""
  List stored client certificates (`GET /hostnames/certificates`).
  """
  def list_certificates(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(certificates_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Upload a client certificate (`POST /hostnames/certificates`).
  """
  def upload_certificate(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(certificates_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a certificate (`GET /hostnames/certificates/:certificate_id`).
  """
  def get_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.get(certificate_path(zone_id, certificate_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a certificate (`DELETE /hostnames/certificates/:certificate_id`).
  """
  def delete_certificate(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.delete(certificate_path(zone_id, certificate_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/origin_tls_client_auth/hostnames"
  defp certificates_path(zone_id), do: base_path(zone_id) <> "/certificates"
  defp certificate_path(zone_id, certificate_id), do: certificates_path(zone_id) <> "/#{encode(certificate_id)}"

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
