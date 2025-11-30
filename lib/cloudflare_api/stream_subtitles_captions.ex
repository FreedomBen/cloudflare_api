defmodule CloudflareApi.StreamSubtitlesCaptions do
  @moduledoc ~S"""
  Manage Stream subtitles and captions at `/accounts/:account_id/stream/:identifier/captions`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List captions/subtitles for a video (`GET /captions`).
  """
  def list(client, account_id, identifier, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id, identifier), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch caption metadata for a language (`GET /captions/:language`).
  """
  def get(client, account_id, identifier, language, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(language_path(account_id, identifier, language), opts))
    |> handle_response()
  end

  @doc ~S"""
  Download the VTT payload for a language (`GET /captions/:language/vtt`).
  """
  def download_vtt(client, account_id, identifier, language) do
    c(client)
    |> Tesla.get(language_path(account_id, identifier, language) <> "/vtt")
    |> handle_response()
  end

  @doc ~S"""
  Upload caption/subtitle content (`PUT /captions/:language`).
  Pass a `Tesla.Multipart` struct or IO data representing the multipart payload.
  """
  def upload(client, account_id, identifier, language, upload_body) do
    c(client)
    |> Tesla.put(language_path(account_id, identifier, language), upload_body)
    |> handle_response()
  end

  @doc ~S"""
  Generate captions for a language (`POST /captions/:language/generate`).
  """
  def generate(client, account_id, identifier, language) do
    c(client)
    |> Tesla.post(language_path(account_id, identifier, language) <> "/generate", %{})
    |> handle_response()
  end

  @doc ~S"""
  Delete captions for a language (`DELETE /captions/:language`).
  """
  def delete(client, account_id, identifier, language) do
    c(client)
    |> Tesla.delete(language_path(account_id, identifier, language), body: %{})
    |> handle_response()
  end

  defp base(account_id, identifier),
    do: "/accounts/#{account_id}/stream/#{encode(identifier)}/captions"

  defp language_path(account_id, identifier, language) do
    base(account_id, identifier) <> "/#{encode(language)}"
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
