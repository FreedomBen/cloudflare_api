defmodule CloudflareApi.AutoragJobs do
  @moduledoc ~S"""
  Manage AutoRAG jobs.
  """

  @doc ~S"""
  List autorag jobs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AutoragJobs.list(client, "account_id", "rag_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, rag_id, opts \\ []) do
    c(client)
    |> Tesla.get(list_url(account_id, rag_id, opts))
    |> handle_response()
  end

  @doc ~S"""
  Get autorag jobs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AutoragJobs.get(client, "account_id", "rag_id", "job_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, rag_id, job_id) do
    c(client)
    |> Tesla.get(job_path(account_id, rag_id, job_id))
    |> handle_response()
  end

  @doc ~S"""
  Logs autorag jobs.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AutoragJobs.logs(client, "account_id", "rag_id", "job_id", [])
      {:ok, %{"id" => "example"}}

  """

  def logs(client, account_id, rag_id, job_id, opts \\ []) do
    c(client)
    |> Tesla.get(job_path(account_id, rag_id, job_id) <> "/logs" <> query_suffix(opts))
    |> handle_response()
  end

  defp list_url(account_id, rag_id, []), do: base_path(account_id, rag_id)
  defp list_url(account_id, rag_id, opts), do: base_path(account_id, rag_id) <> query_suffix(opts)
  defp base_path(account_id, rag_id), do: "/accounts/#{account_id}/autorag/rags/#{rag_id}/jobs"
  defp job_path(account_id, rag_id, job_id), do: base_path(account_id, rag_id) <> "/#{job_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

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
