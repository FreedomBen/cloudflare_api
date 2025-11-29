defmodule CloudflareApi.DlpEmail do
  @moduledoc ~S"""
  Email DLP scanner helpers wrapping `/accounts/:account_id/dlp/email`.
  """

  @doc ~S"""
  Retrieve the current account mapping (`GET /accounts/:account_id/dlp/email/account_mapping`).
  """
  def get_account_mapping(client, account_id) do
    request(client, :get, mapping_path(account_id))
  end

  @doc ~S"""
  Create or update the account mapping (`POST /accounts/:account_id/dlp/email/account_mapping`).
  """
  def create_account_mapping(client, account_id, params) when is_map(params) do
    request(client, :post, mapping_path(account_id), params)
  end

  @doc ~S"""
  List all email scanner rules (`GET /accounts/:account_id/dlp/email/rules`).
  """
  def list_rules(client, account_id) do
    request(client, :get, rules_path(account_id))
  end

  @doc ~S"""
  Create a new email scanner rule (`POST /accounts/:account_id/dlp/email/rules`).
  """
  def create_rule(client, account_id, params) when is_map(params) do
    request(client, :post, rules_path(account_id), params)
  end

  @doc ~S"""
  Update rule priorities (`PATCH /accounts/:account_id/dlp/email/rules`).
  """
  def update_rule_priorities(client, account_id, params) when is_map(params) do
    request(client, :patch, rules_path(account_id), params)
  end

  @doc ~S"""
  Get a single rule (`GET /accounts/:account_id/dlp/email/rules/:rule_id`).
  """
  def get_rule(client, account_id, rule_id) do
    request(client, :get, rule_path(account_id, rule_id))
  end

  @doc ~S"""
  Update a rule (`PUT /accounts/:account_id/dlp/email/rules/:rule_id`).
  """
  def update_rule(client, account_id, rule_id, params) when is_map(params) do
    request(client, :put, rule_path(account_id, rule_id), params)
  end

  @doc ~S"""
  Delete a rule (`DELETE /accounts/:account_id/dlp/email/rules/:rule_id`).
  """
  def delete_rule(client, account_id, rule_id) do
    request(client, :delete, rule_path(account_id, rule_id), %{})
  end

  defp mapping_path(account_id), do: "/accounts/#{account_id}/dlp/email/account_mapping"
  defp rules_path(account_id), do: "/accounts/#{account_id}/dlp/email/rules"
  defp rule_path(account_id, rule_id), do: rules_path(account_id) <> "/#{rule_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:delete, _} -> Tesla.delete(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
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
