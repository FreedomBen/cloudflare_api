defmodule CloudflareApi.CertificatePacks do
  @moduledoc ~S"""
  Manage SSL certificate packs for a zone.
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(zone_id, opts))
    |> handle_response()
  end

  def order(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/order", params)
    |> handle_response()
  end

  def quota(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/quota")
    |> handle_response()
  end

  def get(client, zone_id, pack_id) do
    c(client)
    |> Tesla.get(pack_path(zone_id, pack_id))
    |> handle_response()
  end

  def delete(client, zone_id, pack_id) do
    c(client)
    |> Tesla.delete(pack_path(zone_id, pack_id), body: %{})
    |> handle_response()
  end

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
