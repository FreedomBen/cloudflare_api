defmodule CloudflareApi.CustomPagesAccount do
  @moduledoc ~S"""
  Manage custom pages scoped to an account.
  """

  @doc ~S"""
  List custom pages account.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomPagesAccount.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Get custom pages account.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomPagesAccount.get(client, "account_id", "page_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, page_id) do
    c(client)
    |> Tesla.get(page_path(account_id, page_id))
    |> handle_response()
  end

  @doc ~S"""
  Update custom pages account.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CustomPagesAccount.update(client, "account_id", "page_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, page_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(page_path(account_id, page_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/custom_pages"
  defp page_path(account_id, page_id), do: base_path(account_id) <> "/#{page_id}"

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
