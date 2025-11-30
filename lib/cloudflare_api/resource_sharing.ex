defmodule CloudflareApi.ResourceSharing do
  @moduledoc ~S"""
  Resource sharing APIs under `/accounts/:account_id/shares` and
  `/organizations/:organization_id/shares`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    request(client, :get, with_query(account_base(account_id), opts))
  end

  @doc ~S"""
  Create resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, account_base(account_id), params)
  end

  @doc ~S"""
  Get resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.get(client, "account_id", "share_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, share_id) do
    request(client, :get, share_path(account_id, share_id))
  end

  @doc ~S"""
  Update resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.update(client, "account_id", "share_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, share_id, params) when is_map(params) do
    request(client, :put, share_path(account_id, share_id), params)
  end

  @doc ~S"""
  Delete resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.delete(client, "account_id", "share_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, share_id) do
    request(client, :delete, share_path(account_id, share_id))
  end

  @doc ~S"""
  List recipients for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.list_recipients(client, "account_id", "share_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_recipients(client, account_id, share_id, opts \\ []) do
    request(client, :get, with_query(recipients_path(account_id, share_id), opts))
  end

  @doc ~S"""
  Create recipient for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.create_recipient(client, "account_id", "share_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_recipient(client, account_id, share_id, params) when is_map(params) do
    request(client, :post, recipients_path(account_id, share_id), params)
  end

  @doc ~S"""
  Update recipients for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.update_recipients(client, "account_id", "share_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_recipients(client, account_id, share_id, params) when is_map(params) do
    request(client, :put, recipients_path(account_id, share_id), params)
  end

  @doc ~S"""
  Get recipient for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.get_recipient(client, "account_id", "share_id", "recipient_id")
      {:ok, %{"id" => "example"}}

  """

  def get_recipient(client, account_id, share_id, recipient_id) do
    request(client, :get, recipient_path(account_id, share_id, recipient_id))
  end

  @doc ~S"""
  Delete recipient for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.delete_recipient(client, "account_id", "share_id", "recipient_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_recipient(client, account_id, share_id, recipient_id) do
    request(client, :delete, recipient_path(account_id, share_id, recipient_id))
  end

  @doc ~S"""
  List resources for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.list_resources(client, "account_id", "share_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_resources(client, account_id, share_id, opts \\ []) do
    request(client, :get, with_query(resources_path(account_id, share_id), opts))
  end

  @doc ~S"""
  Create resource for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.create_resource(client, "account_id", "share_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_resource(client, account_id, share_id, params) when is_map(params) do
    request(client, :post, resources_path(account_id, share_id), params)
  end

  @doc ~S"""
  Get resource for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.get_resource(client, "account_id", "share_id", "resource_id")
      {:ok, %{"id" => "example"}}

  """

  def get_resource(client, account_id, share_id, resource_id) do
    request(client, :get, resource_path(account_id, share_id, resource_id))
  end

  @doc ~S"""
  Update resource for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.update_resource(client, "account_id", "share_id", "resource_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_resource(client, account_id, share_id, resource_id, params) when is_map(params) do
    request(client, :put, resource_path(account_id, share_id, resource_id), params)
  end

  @doc ~S"""
  Delete resource for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.delete_resource(client, "account_id", "share_id", "resource_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_resource(client, account_id, share_id, resource_id) do
    request(client, :delete, resource_path(account_id, share_id, resource_id))
  end

  @doc ~S"""
  Organization shares for resource sharing.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ResourceSharing.organization_shares(client, "organization_id", [])
      {:ok, %{"id" => "example"}}

  """

  def organization_shares(client, organization_id, opts \\ []) do
    request(client, :get, with_query("/organizations/#{organization_id}/shares", opts))
  end

  defp account_base(account_id), do: "/accounts/#{account_id}/shares"
  defp share_path(account_id, share_id), do: account_base(account_id) <> "/#{encode(share_id)}"

  defp recipients_path(account_id, share_id),
    do: share_path(account_id, share_id) <> "/recipients"

  defp recipient_path(account_id, share_id, recipient_id) do
    recipients_path(account_id, share_id) <> "/#{encode(recipient_id)}"
  end

  defp resources_path(account_id, share_id), do: share_path(account_id, share_id) <> "/resources"

  defp resource_path(account_id, share_id, resource_id) do
    resources_path(account_id, share_id) <> "/#{encode(resource_id)}"
  end

  defp request(client_or_fun, method, url, body \\ nil) do
    client = c(client_or_fun)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, nil} -> Tesla.delete(client, url, body: %{})
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
      end

    handle_response(result)
  end

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
