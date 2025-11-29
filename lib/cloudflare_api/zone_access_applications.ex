defmodule CloudflareApi.ZoneAccessApplications do
  @moduledoc ~S"""
  Manage Access applications scoped to a zone (`/zones/:zone_id/access/apps`).
  """

  def list(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, app_id) do
    c(client)
    |> Tesla.get(app_path(zone_id, app_id))
    |> handle_response()
  end

  def update(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(app_path(zone_id, app_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, app_id) do
    c(client)
    |> Tesla.delete(app_path(zone_id, app_id), body: %{})
    |> handle_response()
  end

  def patch_settings(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id, app_id), params)
    |> handle_response()
  end

  def put_settings(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id, app_id), params)
    |> handle_response()
  end

  def test_policies(client, zone_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(test_path(zone_id, app_id), opts))
    |> handle_response()
  end

  def revoke_tokens(client, zone_id, app_id) do
    c(client)
    |> Tesla.post(revoke_path(zone_id, app_id), %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/access/apps"
  defp app_path(zone_id, app_id), do: base_path(zone_id) <> "/#{app_id}"
  defp settings_path(zone_id, app_id), do: app_path(zone_id, app_id) <> "/settings"

  defp test_path(zone_id, app_id),
    do: app_path(zone_id, app_id) <> "/user_policy_checks"

  defp revoke_path(zone_id, app_id), do: app_path(zone_id, app_id) <> "/revoke_tokens"

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
