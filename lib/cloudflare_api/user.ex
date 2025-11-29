defmodule CloudflareApi.User do
  @moduledoc ~S"""
  Access authenticated user details via `/user` and `/users/tenants`.
  """

  @doc ~S"""
  Get user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.User.get(client)
      {:ok, %{"id" => "example"}}

  """

  def get(client) do
    c(client)
    |> Tesla.get("/user")
    |> handle_response()
  end

  @doc ~S"""
  Update user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.User.update(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, params) when is_map(params) do
    c(client)
    |> Tesla.patch("/user", params)
    |> handle_response()
  end

  @doc ~S"""
  List tenants for user.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.User.list_tenants(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_tenants(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/users/tenants", opts))
    |> handle_response()
  end

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
