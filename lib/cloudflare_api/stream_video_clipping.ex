defmodule CloudflareApi.StreamVideoClipping do
  @moduledoc ~S"""
  Clip Stream videos via `/accounts/:account_id/stream/clip`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Create a clip from a Stream video (`POST /stream/clip`).
  """
  def clip(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(path(account_id), params)
    |> handle_response()
  end

  defp path(account_id), do: "/accounts/#{account_id}/stream/clip"

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
