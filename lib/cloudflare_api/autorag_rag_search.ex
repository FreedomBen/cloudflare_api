defmodule CloudflareApi.AutoragRagSearch do
  @moduledoc ~S"""
  Execute searches against AutoRAG collections.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Search autorag rag search.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AutoragRagSearch.search(client, "account_id", "rag_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def search(client, account_id, rag_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(search_path(account_id, rag_id), params)
    |> handle_response()
  end

  defp search_path(account_id, rag_id),
    do: "/accounts/#{account_id}/autorag/rags/#{rag_id}/search"

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
