defmodule CloudflareApi.AccountOwnedApiTokens do
  @moduledoc ~S"""
  Manage account-owned API tokens, including permission groups and verification.
  """

  @doc ~S"""
  List account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Create account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.get(client, "account_id", "token_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, token_id) do
    c(client)
    |> Tesla.get(token_path(account_id, token_id))
    |> handle_response()
  end

  @doc ~S"""
  Update account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.update(client, "account_id", "token_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, token_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(token_path(account_id, token_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Roll account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.roll(client, "account_id", "token_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def roll(client, account_id, token_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(token_path(account_id, token_id) <> "/value", params)
    |> handle_response()
  end

  @doc ~S"""
  Delete account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.delete(client, "account_id", "token_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, token_id) do
    c(client)
    |> Tesla.delete(token_path(account_id, token_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Permission groups for account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.permission_groups(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def permission_groups(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/tokens/permission_groups")
    |> handle_response()
  end

  @doc ~S"""
  Verify account owned api tokens.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountOwnedApiTokens.verify(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def verify(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/tokens/verify")
    |> handle_response()
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/tokens"
  defp token_path(account_id, token_id), do: base_path(account_id) <> "/#{token_id}"

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
