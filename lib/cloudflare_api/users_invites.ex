defmodule CloudflareApi.UsersInvites do
  @moduledoc ~S"""
  Manage user invitations via `/user/invites`.
  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/invites", opts))
    |> handle_response()
  end

  def get(client, invite_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(invite_path(invite_id), opts))
    |> handle_response()
  end

  def respond(client, invite_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(invite_path(invite_id), params)
    |> handle_response()
  end

  defp invite_path(invite_id), do: "/user/invites/#{encode(invite_id)}"
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
