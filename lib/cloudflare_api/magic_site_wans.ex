defmodule CloudflareApi.MagicSiteWans do
  @moduledoc ~S"""
  Manage Magic Site WANs (`/accounts/:account_id/magic/sites/:site_id/wans`).
  """

  def list(client, account_id, site_id, opts \\ []) do
    request(client, :get, base(account_id, site_id) <> query(opts))
  end

  def create(client, account_id, site_id, params) when is_map(params) do
    request(client, :post, base(account_id, site_id), params)
  end

  def get(client, account_id, site_id, wan_id) do
    request(client, :get, wan_path(account_id, site_id, wan_id))
  end

  def update(client, account_id, site_id, wan_id, params) when is_map(params) do
    request(client, :put, wan_path(account_id, site_id, wan_id), params)
  end

  def patch(client, account_id, site_id, wan_id, params) when is_map(params) do
    request(client, :patch, wan_path(account_id, site_id, wan_id), params)
  end

  def delete(client, account_id, site_id, wan_id) do
    request(client, :delete, wan_path(account_id, site_id, wan_id))
  end

  defp base(account_id, site_id), do: "/accounts/#{account_id}/magic/sites/#{site_id}/wans"

  defp wan_path(account_id, site_id, wan_id),
    do: base(account_id, site_id) <> "/#{wan_id}"

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
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
