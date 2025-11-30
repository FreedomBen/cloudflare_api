defmodule CloudflareApi.PerHostnameTlsSettings do
  @moduledoc ~S"""
  Manage per-hostname TLS settings at the zone level via
  `/zones/:zone_id/hostnames/settings/:setting_id`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List hostname overrides for a TLS setting (`GET /hostnames/settings/:setting_id`).
  """
  def list(client, zone_id, setting_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(setting_path(zone_id, setting_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a hostname's TLS setting (`GET /hostnames/settings/:setting_id/:hostname`).
  """
  def get_hostname(client, zone_id, setting_id, hostname) do
    c(client)
    |> Tesla.get(host_path(zone_id, setting_id, hostname))
    |> handle_response()
  end

  @doc ~S"""
  Upsert a hostname's TLS setting (`PUT /hostnames/settings/:setting_id/:hostname`).
  """
  def put_hostname(client, zone_id, setting_id, hostname, params) when is_map(params) do
    c(client)
    |> Tesla.put(host_path(zone_id, setting_id, hostname), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a hostname override (`DELETE /hostnames/settings/:setting_id/:hostname`).
  """
  def delete_hostname(client, zone_id, setting_id, hostname) do
    c(client)
    |> Tesla.delete(host_path(zone_id, setting_id, hostname), body: %{})
    |> handle_response()
  end

  defp setting_path(zone_id, setting_id),
    do: "/zones/#{zone_id}/hostnames/settings/#{encode(setting_id)}"

  defp host_path(zone_id, setting_id, hostname),
    do: setting_path(zone_id, setting_id) <> "/#{encode(hostname)}"

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
