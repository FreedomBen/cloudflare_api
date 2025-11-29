defmodule CloudflareApi.AutoragRagSearch do
  @moduledoc ~S"""
  Execute searches against AutoRAG collections.
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
