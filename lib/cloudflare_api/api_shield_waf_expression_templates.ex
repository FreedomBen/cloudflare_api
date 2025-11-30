defmodule CloudflareApi.ApiShieldWafExpressionTemplates do
  @moduledoc ~S"""
  Manage API Shield WAF expression templates for a zone.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Create or update the fallthrough expression template (`POST /api_gateway/expression-template/fallthrough`).
  """
  def upsert_fallthrough(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post("/zones/#{zone_id}/api_gateway/expression-template/fallthrough", params)
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
