defmodule CloudflareApi.MagicPcapCollection do
  @moduledoc ~S"""
  Manage Magic packet capture requests and bucket ownership (`/accounts/:account_id/pcaps`).
  """

  @doc ~S"""
  List requests for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.list_requests(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_requests(client, account_id) do
    request(client, :get, base(account_id))
  end

  @doc ~S"""
  Create request for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.create_request(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_request(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  @doc ~S"""
  Get request for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.get_request(client, "account_id", "pcap_id")
      {:ok, %{"id" => "example"}}

  """

  def get_request(client, account_id, pcap_id) do
    request(client, :get, request_path(account_id, pcap_id))
  end

  @doc ~S"""
  Download request for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.download_request(client, "account_id", "pcap_id")
      {:ok, %{"id" => "example"}}

  """

  def download_request(client, account_id, pcap_id) do
    request(client, :get, request_path(account_id, pcap_id) <> "/download")
  end

  @doc ~S"""
  Stop request for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.stop_request(client, "account_id", "pcap_id")
      {:ok, %{"id" => "example"}}

  """

  def stop_request(client, account_id, pcap_id) do
    c(client)
    |> Tesla.put(request_path(account_id, pcap_id) <> "/stop", %{})
    |> handle_response()
  end

  @doc ~S"""
  List ownership for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.list_ownership(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_ownership(client, account_id) do
    request(client, :get, ownership_path(account_id))
  end

  @doc ~S"""
  Add ownership for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.add_ownership(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def add_ownership(client, account_id, params) when is_map(params) do
    request(client, :post, ownership_path(account_id), params)
  end

  @doc ~S"""
  Validate ownership for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.validate_ownership(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def validate_ownership(client, account_id, params) when is_map(params) do
    request(client, :post, ownership_path(account_id) <> "/validate", params)
  end

  @doc ~S"""
  Delete ownership for magic pcap collection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.MagicPcapCollection.delete_ownership(client, "account_id", "ownership_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_ownership(client, account_id, ownership_id) do
    request(client, :delete, ownership_path(account_id) <> "/#{ownership_id}")
  end

  defp base(account_id), do: "/accounts/#{account_id}/pcaps"
  defp request_path(account_id, pcap_id), do: base(account_id) <> "/#{pcap_id}"
  defp ownership_path(account_id), do: base(account_id) <> "/ownership"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: 204}}), do: {:ok, :no_content}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
