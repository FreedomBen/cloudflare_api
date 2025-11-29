defmodule CloudflareApi.AccessApplications do
  @moduledoc ~S"""
  Manage Cloudflare Access applications for an account.
  """

  @doc ~S"""
  List access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.get(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id) do
    c(client)
    |> Tesla.get(app_path(account_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Update access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.update(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(app_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.delete(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, app_id) do
    c(client)
    |> Tesla.delete(app_path(account_id, app_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Revoke tokens for access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.revoke_tokens(client, "account_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def revoke_tokens(client, account_id, app_id) do
    c(client)
    |> Tesla.post(app_path(account_id, app_id) <> "/revoke_tokens", %{})
    |> handle_response()
  end

  @doc ~S"""
  Patch settings for access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.patch_settings(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_settings(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(app_path(account_id, app_id) <> "/settings", params)
    |> handle_response()
  end

  @doc ~S"""
  Update settings for access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.update_settings(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_settings(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(app_path(account_id, app_id) <> "/settings", params)
    |> handle_response()
  end

  @doc ~S"""
  Test policies for access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessApplications.test_policies(client, "account_id", "app_id", [])
      {:ok, %{"id" => "example"}}

  """

  def test_policies(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(test_url(account_id, app_id, opts))
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/apps"
  defp app_path(account_id, app_id), do: base_path(account_id) <> "/#{app_id}"

  defp test_url(account_id, app_id, []), do: app_path(account_id, app_id) <> "/user_policy_checks"

  defp test_url(account_id, app_id, opts) do
    test_url(account_id, app_id, []) <> "?" <> CloudflareApi.uri_encode_opts(opts)
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
