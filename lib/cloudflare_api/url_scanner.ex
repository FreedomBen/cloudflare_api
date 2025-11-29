defmodule CloudflareApi.UrlScanner do
  @moduledoc ~S"""
  Access the modern URL Scanner v2 endpoints under `/accounts/:account_id/urlscanner/v2`.
  """

  def create_scan(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/scan", params)
    |> handle_response()
  end

  def create_scan_bulk(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/bulk", params)
    |> handle_response()
  end

  def get_scan(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/result/#{encode(scan_id)}")
    |> handle_response()
  end

  def get_dom(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/dom/#{encode(scan_id)}")
    |> handle_response()
  end

  def get_har(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/har/#{encode(scan_id)}")
    |> handle_response()
  end

  def get_screenshot(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/screenshots/#{encode(scan_id)}.png")
    |> handle_response()
  end

  def get_response(client, account_id, response_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/responses/#{encode(response_id)}")
    |> handle_response()
  end

  def search(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id) <> "/search", opts))
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/urlscanner/v2"

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
