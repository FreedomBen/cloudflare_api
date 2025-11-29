defmodule CloudflareApi.PpcStripe do
  @moduledoc ~S"""
  Configure Pay-Per-Crawl Stripe connections for crawler and publisher roles.

  The underlying endpoints live under `/accounts/:account_id/pay-per-crawl`.
  """

  @doc ~S"""
  Fetch the crawler Stripe configuration (`GET /accounts/:account_id/pay-per-crawl/crawler/stripe`).
  """
  def get_crawler_config(client, account_id) do
    request(client, :get, crawler_path(account_id))
  end

  @doc ~S"""
  Create or reconnect the crawler Stripe configuration (`POST /accounts/:account_id/pay-per-crawl/crawler/stripe`).

  While the OpenAPI schema does not define a body, callers may pass an optional
  map with fields required by Cloudflare's upstream Stripe handshake.
  """
  def create_crawler_config(client, account_id, params \\ %{}) when is_map(params) do
    request(client, :post, crawler_path(account_id), params)
  end

  @doc ~S"""
  Delete the crawler Stripe configuration (`DELETE /accounts/:account_id/pay-per-crawl/crawler/stripe`).
  """
  def delete_crawler_config(client, account_id) do
    request(client, :delete, crawler_path(account_id))
  end

  @doc ~S"""
  Fetch the publisher Stripe configuration (`GET /accounts/:account_id/pay-per-crawl/publisher/stripe`).
  """
  def get_publisher_config(client, account_id) do
    request(client, :get, publisher_path(account_id))
  end

  @doc ~S"""
  Create or reconnect the publisher Stripe configuration (`POST /accounts/:account_id/pay-per-crawl/publisher/stripe`).
  """
  def create_publisher_config(client, account_id, params \\ %{}) when is_map(params) do
    request(client, :post, publisher_path(account_id), params)
  end

  @doc ~S"""
  Delete the publisher Stripe configuration (`DELETE /accounts/:account_id/pay-per-crawl/publisher/stripe`).
  """
  def delete_publisher_config(client, account_id) do
    request(client, :delete, publisher_path(account_id))
  end

  defp crawler_path(account_id),
    do: "/accounts/#{account_id}/pay-per-crawl/crawler/stripe"

  defp publisher_path(account_id),
    do: "/accounts/#{account_id}/pay-per-crawl/publisher/stripe"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
        :post -> Tesla.post(client, url, body || %{})
        :delete -> delete(client, url, body)
      end

    handle_response(result)
  end

  defp delete(client, url, nil), do: Tesla.delete(client, url)
  defp delete(client, url, body), do: Tesla.delete(client, url, body: body)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
