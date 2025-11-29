defmodule CloudflareApi.IpAccessRulesZone do
  @moduledoc ~S"""
  Zone-level IP Access rules (`/zones/:zone_id/firewall/access_rules/rules`).
  """

  def list(client, zone_id, opts \\ []) do
    request(client, :get, base_path(zone_id) <> query_suffix(opts))
  end

  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, base_path(zone_id), params)
  end

  def update(client, zone_id, rule_id, params) when is_map(params) do
    request(client, :patch, item_path(zone_id, rule_id), params)
  end

  def delete(client, zone_id, rule_id, opts \\ []) do
    body =
      case Keyword.fetch(opts, :cascade) do
        {:ok, cascade} -> %{"cascade" => cascade}
        :error -> %{}
      end

    request(client, :delete, item_path(zone_id, rule_id), body)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/firewall/access_rules/rules"
  defp item_path(zone_id, rule_id), do: base_path(zone_id) <> "/#{rule_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)
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
