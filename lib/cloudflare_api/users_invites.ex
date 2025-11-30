defmodule CloudflareApi.UsersInvites do
  @moduledoc ~S"""
  Manage user invitations via `/user/invites`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List users invites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersInvites.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/invites", opts))
    |> handle_response()
  end

  @doc ~S"""
  Get users invites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersInvites.get(client, "invite_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, invite_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(invite_path(invite_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Respond users invites.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersInvites.respond(client, "invite_id", %{})
      {:ok, %{"id" => "example"}}

  """

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
