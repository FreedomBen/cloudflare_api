defmodule CloudflareApi.LeakedCredentialChecks do
  @moduledoc ~S"""
  Manage Cloudflare Leaked Credential Checks for a zone (`/zones/:zone_id/leaked-credential-checks`).
  """

  def get_status(client, zone_id) do
    request(client, :get, base_path(zone_id))
  end

  def set_status(client, zone_id, params) when is_map(params) do
    request(client, :post, base_path(zone_id), params)
  end

  def list_detections(client, zone_id) do
    request(client, :get, detections_path(zone_id))
  end

  def create_detection(client, zone_id, params) when is_map(params) do
    request(client, :post, detections_path(zone_id), params)
  end

  def get_detection(client, zone_id, detection_id) do
    request(client, :get, detection_path(zone_id, detection_id))
  end

  def update_detection(client, zone_id, detection_id, params) when is_map(params) do
    request(client, :put, detection_path(zone_id, detection_id), params)
  end

  def delete_detection(client, zone_id, detection_id) do
    request(client, :delete, detection_path(zone_id, detection_id), %{})
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/leaked-credential-checks"
  defp detections_path(zone_id), do: base_path(zone_id) <> "/detections"
  defp detection_path(zone_id, detection_id), do: detections_path(zone_id) <> "/#{detection_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
      end

    handle_response(result)
  end

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
