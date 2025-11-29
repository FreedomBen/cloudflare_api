defmodule CloudflareApi.UrlScannerDeprecated do
  @moduledoc ~S"""
  Access the legacy URL Scanner endpoints `/accounts/:account_id/urlscanner/*`.
  """

  @doc ~S"""
  Create scan for url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.create_scan(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_scan(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/scan", params)
    |> handle_response()
  end

  @doc ~S"""
  Get scan for url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.get_scan(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_scan(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Get har for url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.get_har(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_har(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}/har")
    |> handle_response()
  end

  @doc ~S"""
  Get screenshot for url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.get_screenshot(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_screenshot(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/scan/#{encode(scan_id)}/screenshot")
    |> handle_response()
  end

  @doc ~S"""
  Get response text for url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.get_response_text(client, "account_id", "response_id")
      {:ok, %{"id" => "example"}}

  """

  def get_response_text(client, account_id, response_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/response/#{encode(response_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Search url scanner deprecated.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScannerDeprecated.search(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

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
