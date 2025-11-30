defmodule CloudflareApi.AccessAppPolicies do
  @moduledoc ~S"""
  Manage application-scoped Access policies for an app.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.list(client, "account_id", "app_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, app_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.create(client, "account_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.get(client, "account_id", "app_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, app_id, policy_id) do
    c(client)
    |> Tesla.get(policy_path(account_id, app_id, policy_id))
    |> handle_response()
  end

  @doc ~S"""
  Update access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.update(client, "account_id", "app_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, app_id, policy_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(policy_path(account_id, app_id, policy_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.delete(client, "account_id", "app_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, app_id, policy_id) do
    c(client)
    |> Tesla.delete(policy_path(account_id, app_id, policy_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Make reusable for access app policies.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccessAppPolicies.make_reusable(client, "account_id", "app_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def make_reusable(client, account_id, app_id, policy_id) do
    c(client)
    |> Tesla.put(policy_path(account_id, app_id, policy_id) <> "/make_reusable", %{})
    |> handle_response()
  end

  defp list_url(account_id, app_id, []), do: base_path(account_id, app_id)

  defp list_url(account_id, app_id, opts) do
    base_path(account_id, app_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id, app_id) do
    "/accounts/#{account_id}/access/apps/#{app_id}/policies"
  end

  defp policy_path(account_id, app_id, policy_id) do
    base_path(account_id, app_id) <> "/#{policy_id}"
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
