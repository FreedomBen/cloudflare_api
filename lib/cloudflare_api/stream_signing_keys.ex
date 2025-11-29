defmodule CloudflareApi.StreamSigningKeys do
  @moduledoc ~S"""
  Manage Stream signing keys under `/accounts/:account_id/stream/keys`.
  """

  @doc ~S"""
  List signing keys (`GET /stream/keys`).
  """
  def list(client, account_id) do
    c(client)
    |> Tesla.get(path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a signing key (`POST /stream/keys`).
  """
  def create(client, account_id, params \\ %{}) do
    c(client)
    |> Tesla.post(path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a signing key (`DELETE /stream/keys/:identifier`).
  """
  def delete(client, account_id, identifier) do
    c(client)
    |> Tesla.delete(path(account_id) <> "/#{encode(identifier)}", body: %{})
    |> handle_response()
  end

  defp path(account_id), do: "/accounts/#{account_id}/stream/keys"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
