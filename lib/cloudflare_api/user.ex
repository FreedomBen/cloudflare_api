defmodule CloudflareApi.User do
  @moduledoc ~S"""
  Access authenticated user details via `/user` and `/users/tenants`.
  """

  def get(client) do
    c(client)
    |> Tesla.get("/user")
    |> handle_response()
  end

  def update(client, params) when is_map(params) do
    c(client)
    |> Tesla.patch("/user", params)
    |> handle_response()
  end

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
