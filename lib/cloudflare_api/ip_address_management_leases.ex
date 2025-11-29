defmodule CloudflareApi.IpAddressManagementLeases do
  @moduledoc ~S"""
  List leases via `/accounts/:account_id/addressing/leases`.
  """

  def list(client, account_id) do
    request(client, :get, "/accounts/#{account_id}/addressing/leases")
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

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
