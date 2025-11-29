defmodule CloudflareApi.SsoConnectors do
  @moduledoc ~S"""
  Manage account-level SSO connectors (`/accounts/:account_id/sso_connectors`).
  """

  def list(client, account_id, opts \\ []) do
    fetch(client, base_path(account_id), opts)
  end

  def init(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  def get(client, account_id, connector_id, opts \\ []) do
    fetch(client, connector_path(account_id, connector_id), opts)
  end

  def update_state(client, account_id, connector_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(connector_path(account_id, connector_id), params)
    |> handle_response()
  end

  def delete(client, account_id, connector_id) do
    c(client)
    |> Tesla.delete(connector_path(account_id, connector_id), body: %{})
    |> handle_response()
  end

  def begin_verification(client, account_id, connector_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(connector_path(account_id, connector_id) <> "/begin_verification", params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/sso_connectors"

  defp connector_path(account_id, connector_id),
    do: base_path(account_id) <> "/#{encode(connector_id)}"

  defp fetch(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

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
