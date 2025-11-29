defmodule CloudflareApi.ZoneLockdown do
  @moduledoc ~S"""
  Manage zone-level firewall lockdown rules.
  """

  @doc ~S"""
  List existing zone lockdown rules (`GET /zones/:zone_id/firewall/lockdowns`).

  Accepts optional query filters such as `:description`, `:priority`, `:page`,
  `:per_page`, etc., matching the Cloudflare API.
  """
  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a new lockdown rule (`POST /zones/:zone_id/firewall/lockdowns`).
  """
  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch a single lockdown rule (`GET /zones/:zone_id/firewall/lockdowns/:id`).
  """
  def get(client, zone_id, rule_id) do
    c(client)
    |> Tesla.get(rule_path(zone_id, rule_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a lockdown rule (`PUT /zones/:zone_id/firewall/lockdowns/:id`).
  """
  def update(client, zone_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(zone_id, rule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a lockdown rule (`DELETE /zones/:zone_id/firewall/lockdowns/:id`).
  """
  def delete(client, zone_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, rule_id), body: %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/firewall/lockdowns"
  defp rule_path(zone_id, rule_id), do: base_path(zone_id) <> "/#{rule_id}"

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
