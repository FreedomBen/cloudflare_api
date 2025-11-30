defmodule CloudflareApi.RepositoryConnections do
  @moduledoc ~S"""
  Manage build repository connections (`/accounts/:account_id/builds/repos/connections`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Upsert repository connections.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RepositoryConnections.upsert(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def upsert(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete repository connections.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RepositoryConnections.delete(client, "account_id", "repo_connection_uuid")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, repo_connection_uuid) do
    c(client)
    |> Tesla.delete(base_path(account_id) <> "/#{encode(repo_connection_uuid)}", body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/builds/repos/connections"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
