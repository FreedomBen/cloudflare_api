defmodule CloudflareApi.RateLimits do
  @moduledoc ~S"""
  Manage zone-level rate limits (`/zones/:zone_id/rate_limits`).
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, rate_limit_id) do
    c(client)
    |> Tesla.get(rule_path(zone_id, rate_limit_id))
    |> handle_response()
  end

  def update(client, zone_id, rate_limit_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(zone_id, rate_limit_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, rate_limit_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, rate_limit_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/rate_limits"
  defp rule_path(zone_id, rate_limit_id), do: base_path(zone_id) <> "/#{rate_limit_id}"

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
