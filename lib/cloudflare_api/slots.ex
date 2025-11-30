defmodule CloudflareApi.Slots do
  @moduledoc ~S"""
  Access Magic WAN slot metadata (`/accounts/:account_id/cni/slots`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List slots for an account (`GET /cni/slots`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a single slot (`GET /cni/slots/:slot`).
  """
  def get(client, account_id, slot_id) do
    c(client)
    |> Tesla.get(base_path(account_id) <> "/#{encode(slot_id)}")
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cni/slots"
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
