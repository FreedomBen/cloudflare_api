defmodule CloudflareApi.Registrations do
  @moduledoc ~S"""
  Manage device registrations (`/accounts/:account_id/devices/registrations`).
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  def get(client, account_id, registration_id) do
    c(client)
    |> Tesla.get(registration_path(account_id, registration_id))
    |> handle_response()
  end

  def delete(client, account_id, registration_id) do
    c(client)
    |> Tesla.delete(registration_path(account_id, registration_id), body: %{})
    |> handle_response()
  end

  def revoke(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/revoke", params)
    |> handle_response()
  end

  def unrevoke(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/unrevoke", params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/devices/registrations"
  defp registration_path(account_id, id), do: base_path(account_id) <> "/#{encode(id)}"

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
