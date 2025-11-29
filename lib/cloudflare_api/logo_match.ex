defmodule CloudflareApi.LogoMatch do
  @moduledoc ~S"""
  Manage logo uploads and matching for Brand Protection.
  """

  @doc ~S"""
  List logo matches for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.list_logo_matches(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_logo_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/logo-matches", opts)
  end

  @doc ~S"""
  Download logo matches for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.download_logo_matches(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def download_logo_matches(client, account_id, opts \\ []) do
    get(client, account_id, "/logo-matches/download", opts)
  end

  @doc ~S"""
  List logos for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.list_logos(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_logos(client, account_id, opts \\ []) do
    get(client, account_id, "/logos", opts)
  end

  @doc ~S"""
  Create logo for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.create_logo(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_logo(client, account_id, params) when is_map(params) do
    post(client, account_id, "/logos", params)
  end

  @doc ~S"""
  Get logo for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.get_logo(client, "account_id", "logo_id")
      {:ok, %{"id" => "example"}}

  """

  def get_logo(client, account_id, logo_id) do
    get(client, account_id, "/logos/#{logo_id}", [])
  end

  @doc ~S"""
  Delete logo for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.delete_logo(client, "account_id", "logo_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_logo(client, account_id, logo_id) do
    delete(client, account_id, "/logos/#{logo_id}", %{})
  end

  @doc ~S"""
  Scan logo for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.scan_logo(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def scan_logo(client, account_id, params) when is_map(params) do
    post(client, account_id, "/scan-logo", params)
  end

  @doc ~S"""
  Scan page for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.scan_page(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def scan_page(client, account_id, params) when is_map(params) do
    post(client, account_id, "/scan-page", params)
  end

  @doc ~S"""
  Signed url for logo match.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.LogoMatch.signed_url(client, [])
      {:ok, %{"id" => "example"}}

  """

  def signed_url(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/signed-url", opts))
    |> handle_response()
  end

  defp get(client, account_id, suffix, opts) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id) <> suffix, opts))
    |> handle_response()
  end

  defp post(client, account_id, suffix, params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> suffix, params)
    |> handle_response()
  end

  defp delete(client, account_id, suffix, params) do
    c(client)
    |> Tesla.delete(base_path(account_id) <> suffix, body: params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/brand-protection"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
