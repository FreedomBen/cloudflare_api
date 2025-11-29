defmodule CloudflareApi.EmailRoutingRoutingRules do
  @moduledoc ~S"""
  Manage Email Routing rules via `/zones/:zone_id/email/routing/rules`.
  """

  def list(client, zone_id) do
    request(client, :get, base(zone_id))
  end

  def create(client, zone_id, params) when is_map(params) do
    request(client, :post, base(zone_id), params)
  end

  def get(client, zone_id, rule_id) do
    request(client, :get, rule_path(zone_id, rule_id))
  end

  def update(client, zone_id, rule_id, params) when is_map(params) do
    request(client, :put, rule_path(zone_id, rule_id), params)
  end

  def delete(client, zone_id, rule_id) do
    request(client, :delete, rule_path(zone_id, rule_id), %{})
  end

  def get_catch_all(client, zone_id) do
    request(client, :get, base(zone_id) <> "/catch_all")
  end

  def update_catch_all(client, zone_id, params) when is_map(params) do
    request(client, :put, base(zone_id) <> "/catch_all", params)
  end

  defp base(zone_id), do: "/zones/#{zone_id}/email/routing/rules"
  defp rule_path(zone_id, id), do: base(zone_id) <> "/#{id}"

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
