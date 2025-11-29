defmodule CloudflareApi.CustomPagesZone do
  @moduledoc ~S"""
  Manage custom pages scoped to a zone.
  """

  def list(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id))
    |> handle_response()
  end

  def get(client, zone_id, page_id) do
    c(client)
    |> Tesla.get(page_path(zone_id, page_id))
    |> handle_response()
  end

  def update(client, zone_id, page_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(page_path(zone_id, page_id), params)
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/custom_pages"
  defp page_path(zone_id, page_id), do: base_path(zone_id) <> "/#{page_id}"

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
