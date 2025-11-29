defmodule CloudflareApi.WebAnalytics do
  @moduledoc ~S"""
  Web Analytics (RUM) helpers for managing sites, rules, and zone settings.
  """

  @doc ~S"""
  Create a Web Analytics site (`POST /accounts/:account_id/rum/site_info`).
  """
  def create_site(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(site_base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List Web Analytics sites (`GET /accounts/:account_id/rum/site_info/list`).

  Supports `:page`, `:per_page`, and `:order_by` options.
  """
  def list_sites(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(site_list_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a Web Analytics site (`GET /accounts/:account_id/rum/site_info/:site_id`).
  """
  def get_site(client, account_id, site_id) do
    c(client)
    |> Tesla.get(site_path(account_id, site_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a Web Analytics site (`PUT /accounts/:account_id/rum/site_info/:site_id`).
  """
  def update_site(client, account_id, site_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(site_path(account_id, site_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Web Analytics site (`DELETE /accounts/:account_id/rum/site_info/:site_id`).
  """
  def delete_site(client, account_id, site_id) do
    c(client)
    |> Tesla.delete(site_path(account_id, site_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Create a Web Analytics rule (`POST /accounts/:account_id/rum/v2/:ruleset_id/rule`).
  """
  def create_rule(client, account_id, ruleset_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(rule_base_path(account_id, ruleset_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Web Analytics rule (`DELETE /accounts/:account_id/rum/v2/:ruleset_id/rule/:rule_id`).
  """
  def delete_rule(client, account_id, ruleset_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(account_id, ruleset_id, rule_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Update a Web Analytics rule (`PUT /accounts/:account_id/rum/v2/:ruleset_id/rule/:rule_id`).
  """
  def update_rule(client, account_id, ruleset_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rule_path(account_id, ruleset_id, rule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List rules within a Web Analytics ruleset (`GET /accounts/:account_id/rum/v2/:ruleset_id/rules`).
  """
  def list_rules(client, account_id, ruleset_id) do
    c(client)
    |> Tesla.get(rules_path(account_id, ruleset_id))
    |> handle_response()
  end

  @doc ~S"""
  Replace the rules inside a Web Analytics ruleset (`POST /accounts/:account_id/rum/v2/:ruleset_id/rules`).
  """
  def modify_rules(client, account_id, ruleset_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(rules_path(account_id, ruleset_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch the zone RUM status (`GET /zones/:zone_id/settings/rum`).
  """
  def get_rum_status(client, zone_id) do
    c(client)
    |> Tesla.get(rum_settings_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Toggle RUM for a zone (`PATCH /zones/:zone_id/settings/rum`).
  """
  def toggle_rum(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(rum_settings_path(zone_id), params)
    |> handle_response()
  end

  defp site_base_path(account_id), do: "/accounts/#{account_id}/rum/site_info"
  defp site_list_path(account_id), do: site_base_path(account_id) <> "/list"
  defp site_path(account_id, site_id), do: site_base_path(account_id) <> "/#{site_id}"

  defp rule_base_path(account_id, ruleset_id),
    do: "/accounts/#{account_id}/rum/v2/#{ruleset_id}/rule"

  defp rule_path(account_id, ruleset_id, rule_id),
    do: "/accounts/#{account_id}/rum/v2/#{ruleset_id}/rule/#{rule_id}"

  defp rules_path(account_id, ruleset_id),
    do: "/accounts/#{account_id}/rum/v2/#{ruleset_id}/rules"

  defp rum_settings_path(zone_id), do: "/zones/#{zone_id}/settings/rum"

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
