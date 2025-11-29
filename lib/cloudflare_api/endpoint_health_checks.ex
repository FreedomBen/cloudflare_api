defmodule CloudflareApi.EndpointHealthChecks do
  @moduledoc ~S"""
  Manage diagnostic endpoint health checks (`/accounts/:account_id/diagnostics/endpoint-healthchecks`).
  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, base(account_id) <> query(opts))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  def get(client, account_id, check_id) do
    request(client, :get, check_path(account_id, check_id))
  end

  def update(client, account_id, check_id, params) when is_map(params) do
    request(client, :put, check_path(account_id, check_id), params)
  end

  def delete(client, account_id, check_id) do
    request(client, :delete, check_path(account_id, check_id), %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/diagnostics/endpoint-healthchecks"
  defp check_path(account_id, id), do: base(account_id) <> "/#{id}"
  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
