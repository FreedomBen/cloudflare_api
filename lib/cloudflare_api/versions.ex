defmodule CloudflareApi.Versions do
  @moduledoc ~S"""
  Manage Workers versions under `/accounts/:account_id/workers/workers/:worker_id/versions`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List versions.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Versions.list(client, "account_id", "worker_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, worker_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id, worker_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create versions.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Versions.create(client, "account_id", "worker_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, worker_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id, worker_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get versions.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Versions.get(client, "account_id", "worker_id", "version_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, worker_id, version_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(version_path(account_id, worker_id, version_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete versions.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Versions.delete(client, "account_id", "worker_id", "version_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, worker_id, version_id) do
    c(client)
    |> Tesla.delete(version_path(account_id, worker_id, version_id), body: %{})
    |> handle_response()
  end

  defp base(account_id, worker_id),
    do: "/accounts/#{account_id}/workers/workers/#{encode(worker_id)}/versions"

  defp version_path(account_id, worker_id, version_id) do
    base(account_id, worker_id) <> "/#{encode(version_id)}"
  end

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
