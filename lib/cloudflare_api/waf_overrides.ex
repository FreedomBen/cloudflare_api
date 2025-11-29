defmodule CloudflareApi.WafOverrides do
  @moduledoc ~S"""
  Manage WAF overrides under `/zones/:zone_id/firewall/waf/overrides`.
  """

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(zone_id), opts))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, override_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(override_path(zone_id, override_id), opts))
    |> handle_response()
  end

  def update(client, zone_id, override_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(override_path(zone_id, override_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, override_id) do
    c(client)
    |> Tesla.delete(override_path(zone_id, override_id), body: %{})
    |> handle_response()
  end

  defp base(zone_id), do: "/zones/#{zone_id}/firewall/waf/overrides"

  defp override_path(zone_id, override_id) do
    base(zone_id) <> "/#{encode(override_id)}"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
