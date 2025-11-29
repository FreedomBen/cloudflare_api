defmodule CloudflareApi.DcvDelegation do
  @moduledoc ~S"""
  Retrieve the delegated DCV UUID for a zone.

  This module wraps the `GET /zones/:zone_id/dcv_delegation/uuid` endpoint and
  follows the same client semantics as the rest of the library
  (`CloudflareApi.new/1` or a zero-arity client function).
  """

  @doc ~S"""
  Retrieve the delegated DCV UUID for a zone (`GET /zones/:zone_id/dcv_delegation/uuid`).

  Returns `{:ok, result}` on success or `{:error, errors}` if Cloudflare responds
  with an error payload or the HTTP request fails.
  """
  def get_uuid(client, zone_id) do
    c(client)
    |> Tesla.get("/zones/#{zone_id}/dcv_delegation/uuid")
    |> handle_response()
  end

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
