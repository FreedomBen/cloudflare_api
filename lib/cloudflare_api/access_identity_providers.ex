defmodule CloudflareApi.AccessIdentityProviders do
  @moduledoc ~S"""
  Manage Cloudflare Access identity providers and SCIM resources.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.get(client, "account_id", "identity_provider_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, identity_provider_id) do
    c(client)
    |> Tesla.get(provider_path(account_id, identity_provider_id))
    |> handle_response()
  end

  @doc ~S"""
  Update access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.update(client, "account_id", "identity_provider_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, identity_provider_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(provider_path(account_id, identity_provider_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.delete(client, "account_id", "identity_provider_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, identity_provider_id) do
    c(client)
    |> Tesla.delete(provider_path(account_id, identity_provider_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List scim groups for access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.list_scim_groups(client, "account_id", "identity_provider_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_scim_groups(client, account_id, identity_provider_id, opts \\ []) do
    c(client)
    |> Tesla.get(scim_groups_url(account_id, identity_provider_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  List scim users for access identity providers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessIdentityProviders.list_scim_users(client, "account_id", "identity_provider_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_scim_users(client, account_id, identity_provider_id, opts \\ []) do
    c(client)
    |> Tesla.get(scim_users_url(account_id, identity_provider_id, opts))
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/identity_providers"

  defp provider_path(account_id, identity_provider_id) do
    base_path(account_id) <> "/#{identity_provider_id}"
  end

  defp scim_groups_url(account_id, identity_provider_id, []),
    do: provider_path(account_id, identity_provider_id) <> "/scim/groups"

  defp scim_groups_url(account_id, identity_provider_id, opts) do
    scim_groups_url(account_id, identity_provider_id, []) <>
      "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp scim_users_url(account_id, identity_provider_id, []),
    do: provider_path(account_id, identity_provider_id) <> "/scim/users"

  defp scim_users_url(account_id, identity_provider_id, opts) do
    scim_users_url(account_id, identity_provider_id, []) <>
      "?" <> CloudflareApi.uri_encode_opts(opts)
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
