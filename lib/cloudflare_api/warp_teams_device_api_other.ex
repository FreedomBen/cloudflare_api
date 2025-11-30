defmodule CloudflareApi.WarpTeamsDeviceApiOther do
  @moduledoc ~S"""
  Fetch override codes for Zero Trust device registrations
  (`/accounts/:account_id/devices/registrations/:registration_id/override_codes`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Retrieve one-time override codes for a registration (`GET .../override_codes`).
  """
  def get_override_codes(client, account_id, registration_id) do
    request(client, :get, path(account_id, registration_id))
  end

  defp path(account_id, registration_id) do
    "/accounts/#{account_id}/devices/registrations/#{encode(registration_id)}/override_codes"
  end

  defp request(client, method, url) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp encode(value), do: value |> to_string() |> URI.encode(&URI.char_unreserved?/1)

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
