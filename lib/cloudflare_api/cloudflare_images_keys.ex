defmodule CloudflareApi.CloudflareImagesKeys do
  @moduledoc ~S"""
  Manage Cloudflare Images signing keys.
  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  def put(client, account_id, key_name, params \\ %{}) when is_map(params) do
    c(client)
    |> Tesla.put(key_path(account_id, key_name), params)
    |> handle_response()
  end

  def delete(client, account_id, key_name) do
    c(client)
    |> Tesla.delete(key_path(account_id, key_name), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/images/v1/keys"
  defp key_path(account_id, key_name), do: base_path(account_id) <> "/#{key_name}"

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
