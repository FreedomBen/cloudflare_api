defmodule CloudflareApi.LoadBalancerHealthcheckEvents do
  @moduledoc ~S"""
  List user-level load balancer healthcheck events (`/user/load_balancing_analytics/events`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List healthcheck events.

  Supports filter options like `:since`, `:until`, `:pool_id`, `:pool_name`,
  `:origin_name`, `:origin_healthy`, and `:pool_healthy`.
  """
  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(base_path() <> query(opts))
    |> handle_response()
  end

  defp base_path, do: "/user/load_balancing_analytics/events"
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
