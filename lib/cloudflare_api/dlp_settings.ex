defmodule CloudflareApi.DlpSettings do
  @moduledoc ~S"""
  DLP settings helpers (limits, payload log, pattern validation).
  """

  @doc ~S"""
  Fetch account DLP limits (`GET /accounts/:account_id/dlp/limits`).
  """
  def limits(client, account_id) do
    request(client, :get, base(account_id) <> "/limits")
  end

  @doc ~S"""
  Validate a regex pattern (`POST /accounts/:account_id/dlp/patterns/validate`).
  """
  def validate_pattern(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/patterns/validate", params)
  end

  @doc ~S"""
  Get payload log settings (`GET /accounts/:account_id/dlp/payload_log`).
  """
  def payload_log(client, account_id) do
    request(client, :get, base(account_id) <> "/payload_log")
  end

  @doc ~S"""
  Update payload log settings (`PUT /accounts/:account_id/dlp/payload_log`).
  """
  def update_payload_log(client, account_id, params) when is_map(params) do
    request(client, :put, base(account_id) <> "/payload_log", params)
  end

  defp base(account_id), do: "/accounts/#{account_id}/dlp"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
