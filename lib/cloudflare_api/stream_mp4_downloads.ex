defmodule CloudflareApi.StreamMp4Downloads do
  @moduledoc ~S"""
  Manage Stream MP4 downloads for a video via `/accounts/:account_id/stream/:identifier/downloads`.
  """

  @doc ~S"""
  List downloads for a video (`GET /downloads`).
  """
  def list(client, account_id, identifier, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id, identifier), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create downloads (`POST /downloads`).
  """
  def create(client, account_id, identifier, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id, identifier), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete all downloads for a video (`DELETE /downloads`).
  """
  def delete(client, account_id, identifier) do
    c(client)
    |> Tesla.delete(base(account_id, identifier), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Create downloads for a specific type (`POST /downloads/:download_type`).
  """
  def create_for_type(client, account_id, identifier, download_type, params)
      when is_map(params) do
    c(client)
    |> Tesla.post(type_path(account_id, identifier, download_type), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete downloads for a specific type (`DELETE /downloads/:download_type`).
  """
  def delete_for_type(client, account_id, identifier, download_type) do
    c(client)
    |> Tesla.delete(type_path(account_id, identifier, download_type), body: %{})
    |> handle_response()
  end

  defp base(account_id, identifier),
    do: "/accounts/#{account_id}/stream/#{encode(identifier)}/downloads"

  defp type_path(account_id, identifier, download_type) do
    base(account_id, identifier) <> "/#{encode(download_type)}"
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
