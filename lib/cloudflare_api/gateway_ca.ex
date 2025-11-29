defmodule CloudflareApi.GatewayCa do
  @moduledoc ~S"""
  Manage Access Gateway SSH certificate authorities via
  `/accounts/:account_id/access/gateway_ca`.
  """

  @doc ~S"""
  List existing SSH certificate authorities (`GET /accounts/:account_id/access/gateway_ca`).
  """
  def list(client, account_id) do
    request(client, :get, base_path(account_id))
  end

  @doc ~S"""
  Create a new SSH certificate authority (`POST /accounts/:account_id/access/gateway_ca`).

  Pass a map containing the public key material (for example `%{"public_key" => "ssh-rsa AAA..."}`).
  """
  def create(client, account_id, params) when is_map(params) do
    request(client, :post, base_path(account_id), params)
  end

  @doc ~S"""
  Delete an SSH certificate authority (`DELETE /accounts/:account_id/access/gateway_ca/:certificate_id`).
  """
  def delete(client, account_id, certificate_id) do
    request(client, :delete, cert_path(account_id, certificate_id))
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/access/gateway_ca"
  defp cert_path(account_id, certificate_id), do: base_path(account_id) <> "/#{certificate_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, %{} = params} ->
          Tesla.post(client, url, params)

        {:delete, nil} ->
          Tesla.delete(client, url)
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
