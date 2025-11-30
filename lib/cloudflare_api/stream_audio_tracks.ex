defmodule CloudflareApi.StreamAudioTracks do
  @moduledoc ~S"""
  Manage Stream audio tracks for a video via `/accounts/:account_id/stream/:identifier/audio`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List audio tracks for a Stream video (`GET /audio`).
  """
  def list(client, account_id, identifier, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id, identifier), opts))
    |> handle_response()
  end

  @doc ~S"""
  Copy/add an audio track (`POST /audio/copy`).
  """
  def add(client, account_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id, identifier) <> "/copy", params)
    |> handle_response()
  end

  @doc ~S"""
  Update an audio track (`PATCH /audio/:audio_identifier`).
  """
  def update(client, account_id, identifier, audio_identifier, params) when is_map(params) do
    c(client)
    |> Tesla.patch(audio_path(account_id, identifier, audio_identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an audio track (`DELETE /audio/:audio_identifier`).
  """
  def delete(client, account_id, identifier, audio_identifier) do
    c(client)
    |> Tesla.delete(audio_path(account_id, identifier, audio_identifier), body: %{})
    |> handle_response()
  end

  defp base(account_id, identifier),
    do: "/accounts/#{account_id}/stream/#{encode(identifier)}/audio"

  defp audio_path(account_id, identifier, audio_identifier) do
    base(account_id, identifier) <> "/#{encode(audio_identifier)}"
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
