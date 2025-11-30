defmodule CloudflareApi.Sessions do
  @moduledoc ~S"""
  Access Realtime Kit session analytics under `/accounts/:account_id/realtime/kit/:app_id/sessions`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List sessions for an app (`GET /sessions`).
  """
  def list(client, account_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id, app_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch details for a single session (`GET /sessions/:session_id`).
  """
  def get(client, account_id, app_id, session_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(session_path(account_id, app_id, session_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Download chat metadata (`GET /sessions/:session_id/chat`).
  """
  def chat(client, account_id, app_id, session_id) do
    c(client)
    |> Tesla.get(session_path(account_id, app_id, session_id) <> "/chat")
    |> handle_response()
  end

  @doc ~S"""
  List participants for a session (`GET /sessions/:session_id/participants`).
  """
  def participants(client, account_id, app_id, session_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(session_path(account_id, app_id, session_id) <> "/participants", opts)
    )
    |> handle_response()
  end

  @doc ~S"""
  Fetch a participant by ID (`GET /sessions/:session_id/participants/:participant_id`).
  """
  def participant(client, account_id, app_id, session_id, participant_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(
        session_path(account_id, app_id, session_id) <> "/participants/#{encode(participant_id)}",
        opts
      )
    )
    |> handle_response()
  end

  @doc ~S"""
  Fetch participant data by peer ID (`GET /sessions/peer-report/:peer_id`).
  """
  def participant_from_peer(client, account_id, app_id, peer_id, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(base_path(account_id, app_id) <> "/peer-report/#{encode(peer_id)}", opts)
    )
    |> handle_response()
  end

  @doc ~S"""
  Retrieve transcript summary (`GET /sessions/:session_id/summary`).
  """
  def summary(client, account_id, app_id, session_id) do
    c(client)
    |> Tesla.get(session_path(account_id, app_id, session_id) <> "/summary")
    |> handle_response()
  end

  @doc ~S"""
  Trigger summary generation (`POST /sessions/:session_id/summary`).
  """
  def generate_summary(client, account_id, app_id, session_id) do
    c(client)
    |> Tesla.post(session_path(account_id, app_id, session_id) <> "/summary", %{})
    |> handle_response()
  end

  @doc ~S"""
  Retrieve transcript download info (`GET /sessions/:session_id/transcript`).
  """
  def transcript(client, account_id, app_id, session_id) do
    c(client)
    |> Tesla.get(session_path(account_id, app_id, session_id) <> "/transcript")
    |> handle_response()
  end

  defp base_path(account_id, app_id) do
    "/accounts/#{account_id}/realtime/kit/#{encode(app_id)}/sessions"
  end

  defp session_path(account_id, app_id, session_id) do
    base_path(account_id, app_id) <> "/#{encode(session_id)}"
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
