defmodule CloudflareApi.StreamWatermarkProfile do
  @moduledoc ~S"""
  Manage Stream watermark profiles via `/accounts/:account_id/stream/watermarks`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List watermark profiles (`GET /stream/watermarks`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Upload a watermark profile (`POST /stream/watermarks`).

  Accepts a `Tesla.Multipart` or IO data representing the multipart payload.
  """
  def create(client, account_id, upload_body) do
    c(client)
    |> Tesla.post(base(account_id), upload_body)
    |> handle_response()
  end

  @doc ~S"""
  Fetch watermark profile details (`GET /stream/watermarks/:id`).
  """
  def get(client, account_id, identifier) do
    c(client)
    |> Tesla.get(profile_path(account_id, identifier))
    |> handle_response()
  end

  @doc ~S"""
  Delete a watermark profile (`DELETE /stream/watermarks/:id`).
  """
  def delete(client, account_id, identifier) do
    c(client)
    |> Tesla.delete(profile_path(account_id, identifier), body: %{})
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/stream/watermarks"

  defp profile_path(account_id, identifier) do
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
