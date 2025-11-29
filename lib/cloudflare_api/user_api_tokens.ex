defmodule CloudflareApi.UserApiTokens do
  @moduledoc ~S"""
  Manage user-level API tokens under `/user/tokens`.
  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/tokens", opts))
    |> handle_response()
  end

  def create(client, params) when is_map(params) do
    c(client)
    |> Tesla.post("/user/tokens", params)
    |> handle_response()
  end

  def permission_groups(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/tokens/permission_groups", opts))
    |> handle_response()
  end

  def verify(client) do
    c(client)
    |> Tesla.get("/user/tokens/verify")
    |> handle_response()
  end

  def get(client, token_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(token_path(token_id), opts))
    |> handle_response()
  end

  def update(client, token_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(token_path(token_id), params)
    |> handle_response()
  end

  def delete(client, token_id) do
    c(client)
    |> Tesla.delete(token_path(token_id), body: %{})
    |> handle_response()
  end

  def roll_token(client, token_id, params \\ %{}) do
    c(client)
    |> Tesla.put(token_path(token_id) <> "/value", params)
    |> handle_response()
  end

  defp token_path(token_id), do: "/user/tokens/#{encode(token_id)}"

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
