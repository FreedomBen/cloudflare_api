defmodule CloudflareApi.ZeroTrustGatewayRules do
  @moduledoc ~S"""
  Manage Zero Trust Gateway rules (`/accounts/:account_id/gateway/rules`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List rules (`GET /accounts/:account_id/gateway/rules`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  List tenant-scoped rules (`GET /accounts/:account_id/gateway/rules/tenant`).
  """
  def list_tenant_rules(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(tenant_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Create a rule (`POST /accounts/:account_id/gateway/rules`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a rule (`DELETE .../rules/:rule_id`).
  """
  def delete(client, account_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(account_id, rule_id), body: %{})
    |> handle_response()
  end

  @doc """
  Get rule details (`GET .../rules/:rule_id`).
  """
  def get(client, account_id, rule_id) do
    c(client)
    |> Tesla.get(rule_path(account_id, rule_id))
    |> handle_response()
  end

  @doc """
  Update a rule (`PUT .../rules/:rule_id`).
  """
  def update(client, account_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(account_id, rule_id), params)
    |> handle_response()
  end

  @doc """
  Reset rule expiration (`POST .../rules/:rule_id/reset_expiration`).
  """
  def reset_expiration(client, account_id, rule_id, params \\ %{}) do
    c(client)
    |> Tesla.post(reset_expiration_path(account_id, rule_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/rules"
  defp tenant_path(account_id), do: base_path(account_id) <> "/tenant"

  defp rule_path(account_id, rule_id),
    do: base_path(account_id) <> "/#{encode(rule_id)}"

  defp reset_expiration_path(account_id, rule_id),
    do: rule_path(account_id, rule_id) <> "/reset_expiration"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
