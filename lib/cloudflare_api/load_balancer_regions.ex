defmodule CloudflareApi.LoadBalancerRegions do
  @moduledoc ~S"""
  List load balancer regions for an account (`/accounts/:account_id/load_balancers/regions`).
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(base(account_id) <> query(opts))
    |> handle_response()
  end

  def get(client, account_id, region_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/#{region_id}")
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/load_balancers/regions"
  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
