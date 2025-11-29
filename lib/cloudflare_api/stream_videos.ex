defmodule CloudflareApi.StreamVideos do
  @moduledoc ~S"""
  Manage Stream videos under `/accounts/:account_id/stream`.
  """

  @doc ~S"""
  List videos (`GET /stream`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Initiate uploads via TUS (`POST /stream`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Upload a video from a URL (`POST /stream/copy`).
  """
  def upload_from_url(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/copy", params)
    |> handle_response()
  end

  @doc ~S"""
  Create a direct upload token (`POST /stream/direct_upload`).
  """
  def create_direct_upload(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/direct_upload", params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch storage usage (`GET /stream/storage-usage`).
  """
  def storage_usage(client, account_id) do
    c(client)
    |> Tesla.get(base(account_id) <> "/storage-usage")
    |> handle_response()
  end

  @doc ~S"""
  Retrieve video details (`GET /stream/:identifier`).
  """
  def get(client, account_id, identifier, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(video_path(account_id, identifier), opts))
    |> handle_response()
  end

  @doc ~S"""
  Update video details (`POST /stream/:identifier`).
  """
  def update(client, account_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.post(video_path(account_id, identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a video (`DELETE /stream/:identifier`).
  """
  def delete(client, account_id, identifier) do
    c(client)
    |> Tesla.delete(video_path(account_id, identifier), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Retrieve embed code HTML (`GET /stream/:identifier/embed`).
  """
  def embed_code(client, account_id, identifier) do
    c(client)
    |> Tesla.get(video_path(account_id, identifier) <> "/embed")
    |> handle_response()
  end

  @doc ~S"""
  Create signed URL tokens (`POST /stream/:identifier/token`).
  """
  def create_token(client, account_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.post(video_path(account_id, identifier) <> "/token", params)
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/stream"

  defp video_path(account_id, identifier) do
    base(account_id) <> "/#{encode(identifier)}"
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
