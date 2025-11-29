defmodule CloudflareApi.SslVerification do
  @moduledoc ~S"""
  Manage SSL verification details (`/zones/:zone_id/ssl/verification`).
  """

  def details(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(path(zone_id), opts))
    |> handle_response()
  end

  def update_pack_method(client, zone_id, certificate_pack_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(pack_path(zone_id, certificate_pack_id), params)
    |> handle_response()
  end

  defp path(zone_id), do: "/zones/#{zone_id}/ssl/verification"
  defp pack_path(zone_id, pack_id), do: path(zone_id) <> "/#{pack_id}"

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
