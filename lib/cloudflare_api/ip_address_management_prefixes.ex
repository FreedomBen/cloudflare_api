defmodule CloudflareApi.IpAddressManagementPrefixes do
  @moduledoc ~S"""
  Prefix management helpers for the IP Address Management API.
  """

  @doc ~S"""
  List ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Get ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.get(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, prefix_id) do
    request(client, :get, prefix_path(account_id, prefix_id))
  end

  @doc ~S"""
  Update ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.update(client, "account_id", "prefix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, prefix_id, params) when is_map(params) do
    request(client, :patch, prefix_path(account_id, prefix_id), params)
  end

  @doc ~S"""
  Delete ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.delete(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, prefix_id) do
    request(client, :delete, prefix_path(account_id, prefix_id), %{})
  end

  @doc ~S"""
  Validate ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.validate(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def validate(client, account_id, prefix_id) do
    request(client, :post, prefix_path(account_id, prefix_id) <> "/validate", %{})
  end

  @doc ~S"""
  Download loa document for ip address management prefixes.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.IpAddressManagementPrefixes.download_loa_document(client, "account_id", "loa_document_id")
      {:ok, %{"id" => "example"}}

  """

  def download_loa_document(client, account_id, loa_document_id) do
    request(
      client,
      :get,
      "/accounts/#{account_id}/addressing/loa_documents/#{loa_document_id}/download"
    )
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/addressing/prefixes"
  defp prefix_path(account_id, prefix_id), do: base_path(account_id) <> "/#{prefix_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:patch, %{} = params} ->
          Tesla.patch(client, url, params)

        {:delete, %{} = params} ->
          Tesla.delete(client, url, body: params)

        {:post, _} ->
          Tesla.post(client, url, "")
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
