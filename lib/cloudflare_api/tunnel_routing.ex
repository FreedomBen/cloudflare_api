defmodule CloudflareApi.TunnelRouting do
  @moduledoc ~S"""
  Manage tunnel routes under `/accounts/:account_id/teamnet/routes`.
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  def create_with_cidr(client, account_id, cidr, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/network/#{encode(cidr)}", params)
    |> handle_response()
  end

  def get(client, account_id, route_id) do
    c(client)
    |> Tesla.get(route_path(account_id, route_id))
    |> handle_response()
  end

  def get_by_ip(client, account_id, ip) do
    c(client)
    |> Tesla.get(base(account_id) <> "/ip/#{encode(ip)}")
    |> handle_response()
  end

  def update(client, account_id, route_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(route_path(account_id, route_id), params)
    |> handle_response()
  end

  def update_with_cidr(client, account_id, cidr, params) when is_map(params) do
    c(client)
    |> Tesla.patch(base(account_id) <> "/network/#{encode(cidr)}", params)
    |> handle_response()
  end

  def delete(client, account_id, route_id) do
    c(client)
    |> Tesla.delete(route_path(account_id, route_id), body: %{})
    |> handle_response()
  end

  def delete_with_cidr(client, account_id, cidr) do
    c(client)
    |> Tesla.delete(base(account_id) <> "/network/#{encode(cidr)}", body: %{})
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/teamnet/routes"

  defp route_path(account_id, route_id) do
    base(account_id) <> "/#{encode(route_id)}"
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
