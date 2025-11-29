defmodule CloudflareApi.CustomSsl do
  @moduledoc ~S"""
  Manage custom SSL certificates for a zone.
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> query_suffix(opts))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.get(item_path(zone_id, certificate_id))
    |> handle_response()
  end

  def update(client, zone_id, certificate_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(item_path(zone_id, certificate_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, certificate_id) do
    c(client)
    |> Tesla.delete(item_path(zone_id, certificate_id), body: %{})
    |> handle_response()
  end

  def prioritize(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id) <> "/prioritize", params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/custom_certificates"
  defp item_path(zone_id, certificate_id), do: base_path(zone_id) <> "/#{certificate_id}"
  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
