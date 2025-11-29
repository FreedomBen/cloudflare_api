defmodule CloudflareApi.UrlScanner do
  @moduledoc ~S"""
  Access the modern URL Scanner v2 endpoints under `/accounts/:account_id/urlscanner/v2`.
  """

  @doc ~S"""
  Create scan for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.create_scan(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_scan(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/scan", params)
    |> handle_response()
  end

  @doc ~S"""
  Create scan bulk for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.create_scan_bulk(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_scan_bulk(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/bulk", params)
    |> handle_response()
  end

  @doc ~S"""
  Get scan for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.get_scan(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_scan(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/result/#{encode(scan_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Get dom for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.get_dom(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_dom(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/dom/#{encode(scan_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Get har for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.get_har(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_har(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/har/#{encode(scan_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Get screenshot for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.get_screenshot(client, "account_id", "scan_id")
      {:ok, %{"id" => "example"}}

  """

  def get_screenshot(client, account_id, scan_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/screenshots/#{encode(scan_id)}.png")
    |> handle_response()
  end

  @doc ~S"""
  Get response for url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.get_response(client, "account_id", "response_id")
      {:ok, %{"id" => "example"}}

  """

  def get_response(client, account_id, response_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/responses/#{encode(response_id)}")
    |> handle_response()
  end

  @doc ~S"""
  Search url scanner.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UrlScanner.search(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

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
