defmodule CloudflareApi.ContentScanning do
  @moduledoc ~S"""
  Control Content Upload Scanning for a zone.
  """

  def enable(client, zone_id) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/enable", %{})
    |> handle_response()
  end

  def disable(client, zone_id) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/disable", %{})
    |> handle_response()
  end

  def settings(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/settings")
    |> handle_response()
  end

  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id) <> "/settings", params)
    |> handle_response()
  end

  def list_payloads(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/payloads")
    |> handle_response()
  end

  def add_payloads(client, zone_id, payloads) when is_list(payloads) do
    c(client)
    |> Tesla.post(base_path(zone_id) <> "/payloads", payloads)
    |> handle_response()
  end

  def delete_payload(client, zone_id, expression_id) do
    c(client)
    |> Tesla.delete(base_path(zone_id) <> "/payloads/#{expression_id}", body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/content-upload-scan"

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
