defmodule CloudflareApi.AccountResourceGroups do
  @moduledoc ~S"""
  Manage IAM resource groups for an account.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List account resource groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountResourceGroups.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create account resource groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountResourceGroups.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get account resource groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountResourceGroups.get(client, "account_id", "group_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, group_id) do
    c(client)
    |> Tesla.get(group_path(account_id, group_id))
    |> handle_response()
  end

  @doc ~S"""
  Update account resource groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountResourceGroups.update(client, "account_id", "group_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, group_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(group_path(account_id, group_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete account resource groups.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountResourceGroups.delete(client, "account_id", "group_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, group_id) do
    c(client)
    |> Tesla.delete(group_path(account_id, group_id), body: %{})
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/iam/resource_groups"
  defp group_path(account_id, group_id), do: base_path(account_id) <> "/#{group_id}"

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
