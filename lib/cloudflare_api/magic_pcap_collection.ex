defmodule CloudflareApi.MagicPcapCollection do
  @moduledoc ~S"""
  Manage Magic packet capture requests and bucket ownership (`/accounts/:account_id/pcaps`).
  """

  def list_requests(client, account_id) do
    request(client, :get, base(account_id))
  end

  def create_request(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id), params)
  end

  def get_request(client, account_id, pcap_id) do
    request(client, :get, request_path(account_id, pcap_id))
  end

  def download_request(client, account_id, pcap_id) do
    request(client, :get, request_path(account_id, pcap_id) <> "/download")
  end

  def stop_request(client, account_id, pcap_id) do
    c(client)
    |> Tesla.put(request_path(account_id, pcap_id) <> "/stop", %{})
    |> handle_response()
  end

  def list_ownership(client, account_id) do
    request(client, :get, ownership_path(account_id))
  end

  def add_ownership(client, account_id, params) when is_map(params) do
    request(client, :post, ownership_path(account_id), params)
  end

  def validate_ownership(client, account_id, params) when is_map(params) do
    request(client, :post, ownership_path(account_id) <> "/validate", params)
  end

  def delete_ownership(client, account_id, ownership_id) do
    request(client, :delete, ownership_path(account_id) <> "/#{ownership_id}")
  end

  defp base(account_id), do: "/accounts/#{account_id}/pcaps"
  defp request_path(account_id, pcap_id), do: base(account_id) <> "/#{pcap_id}"
  defp ownership_path(account_id), do: base(account_id) <> "/ownership"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:delete, _} -> Tesla.delete(client, url)
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: 204}}), do: {:ok, :no_content}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
