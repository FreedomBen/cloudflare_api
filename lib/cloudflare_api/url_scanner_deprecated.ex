defmodule CloudflareApi.UrlScannerDeprecated do
  @moduledoc ~S"""
  Access the legacy URL Scanner endpoints `/accounts/:account_id/urlscanner/*`.
  """

  def create_scan(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/scan", params)
    |> handle_response()
  end

  def get_scan(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}")
    |> handle_response()
  end

  def get_har(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}/har")
    |> handle_response()
  end

  def get_screenshot(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}/screenshot")
    |> handle_response()
  end

  def get_response_text(client, account_id, response_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/response/#{encode(response_id)}")
    |> handle_response()
  end

  def search(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id) <> "/scan", opts))
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/urlscanner"

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
