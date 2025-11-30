defmodule CloudflareApi.ZeroTrustUsers do
  @moduledoc ~S"""
  Access Zero Trust user information (`/accounts/:account_id/access/users`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List users (`GET /accounts/:account_id/access/users`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  List active sessions (`GET .../users/:user_id/active_sessions`).
  """
  def list_active_sessions(client, account_id, user_id) do
    c(client)
    |> Tesla.get(active_sessions_path(account_id, user_id))
    |> handle_response()
  end

  @doc """
  Fetch a single active session (`GET .../active_sessions/:nonce`).
  """
  def get_active_session(client, account_id, user_id, nonce) do
    c(client)
    |> Tesla.get(active_session_path(account_id, user_id, nonce))
    |> handle_response()
  end

  @doc """
  Fetch failed login attempts (`GET .../failed_logins`).
  """
  def get_failed_logins(client, account_id, user_id) do
    c(client)
    |> Tesla.get(failed_logins_path(account_id, user_id))
    |> handle_response()
  end

  @doc """
  Fetch last seen identity info (`GET .../last_seen_identity`).
  """
  def get_last_seen_identity(client, account_id, user_id) do
    c(client)
    |> Tesla.get(last_seen_identity_path(account_id, user_id))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/users"

  defp active_sessions_path(account_id, user_id),
    do: base_path(account_id) <> "/#{encode(user_id)}/active_sessions"

  defp active_session_path(account_id, user_id, nonce),
    do: active_sessions_path(account_id, user_id) <> "/#{encode(nonce)}"

  defp failed_logins_path(account_id, user_id),
    do: base_path(account_id) <> "/#{encode(user_id)}/failed_logins"

  defp last_seen_identity_path(account_id, user_id),
    do: base_path(account_id) <> "/#{encode(user_id)}/last_seen_identity"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
