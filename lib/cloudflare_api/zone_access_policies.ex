defmodule CloudflareApi.ZoneAccessPolicies do
  @moduledoc ~S"""
  Manage Access policies for a specific zone application.
  """

  def list(client, zone_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id, app_id), opts))
    |> handle_response()
  end

  def create(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id, app_id), params)
    |> handle_response()
  end

  def get(client, zone_id, app_id, policy_id) do
    c(client)
    |> Tesla.get(policy_path(zone_id, app_id, policy_id))
    |> handle_response()
  end

  def update(client, zone_id, app_id, policy_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(policy_path(zone_id, app_id, policy_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, app_id, policy_id) do
    c(client)
    |> Tesla.delete(policy_path(zone_id, app_id, policy_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id, app_id), do: "/zones/#{zone_id}/access/apps/#{app_id}/policies"

  defp policy_path(zone_id, app_id, policy_id),
    do: base_path(zone_id, app_id) <> "/#{policy_id}"

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
