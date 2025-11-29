defmodule CloudflareApi.DosFlowtrackdApi do
  @moduledoc ~S"""
  Configure Magic Advanced DDoS (Flowtrackd) protections for DNS and TCP.
  """

  ## DNS protection rules

  def list_dns_protection_rules(client, account_id, opts \\ []) do
    get(client, dns_rules_path(account_id), opts)
  end

  def create_dns_protection_rule(client, account_id, params) when is_map(params) do
    post(client, dns_rules_path(account_id), params)
  end

  def delete_dns_protection_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, dns_rules_path(account_id), params)
  end

  def get_dns_protection_rule(client, account_id, rule_id) do
    get(client, dns_rules_path(account_id) <> "/#{rule_id}", [])
  end

  def update_dns_protection_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, dns_rules_path(account_id) <> "/#{rule_id}", params)
  end

  def delete_dns_protection_rule(client, account_id, rule_id) do
    delete(client, dns_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## Allowlist prefixes

  def list_allowlist_prefixes(client, account_id, opts \\ []) do
    get(client, allowlist_path(account_id), opts)
  end

  def create_allowlist_prefix(client, account_id, params) when is_map(params) do
    post(client, allowlist_path(account_id), params)
  end

  def delete_allowlist_prefixes(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, allowlist_path(account_id), params)
  end

  def get_allowlist_prefix(client, account_id, prefix_id) do
    get(client, allowlist_path(account_id) <> "/#{prefix_id}", [])
  end

  def update_allowlist_prefix(client, account_id, prefix_id, params) when is_map(params) do
    patch(client, allowlist_path(account_id) <> "/#{prefix_id}", params)
  end

  def delete_allowlist_prefix(client, account_id, prefix_id) do
    delete(client, allowlist_path(account_id) <> "/#{prefix_id}", %{})
  end

  ## Advanced TCP prefixes

  def list_prefixes(client, account_id, opts \\ []) do
    get(client, prefixes_path(account_id), opts)
  end

  def create_prefix(client, account_id, params) when is_map(params) do
    post(client, prefixes_path(account_id), params)
  end

  def bulk_create_prefixes(client, account_id, params) when is_map(params) do
    post(client, prefixes_path(account_id) <> "/bulk", params)
  end

  def delete_prefixes(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, prefixes_path(account_id), params)
  end

  def get_prefix(client, account_id, prefix_id) do
    get(client, prefixes_path(account_id) <> "/#{prefix_id}", [])
  end

  def update_prefix(client, account_id, prefix_id, params) when is_map(params) do
    patch(client, prefixes_path(account_id) <> "/#{prefix_id}", params)
  end

  def delete_prefix(client, account_id, prefix_id) do
    delete(client, prefixes_path(account_id) <> "/#{prefix_id}", %{})
  end

  ## SYN protection filters

  def list_syn_protection_filters(client, account_id, opts \\ []) do
    get(client, syn_filters_path(account_id), opts)
  end

  def create_syn_protection_filter(client, account_id, params) when is_map(params) do
    post(client, syn_filters_path(account_id), params)
  end

  def delete_syn_protection_filters(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, syn_filters_path(account_id), params)
  end

  def get_syn_protection_filter(client, account_id, filter_id) do
    get(client, syn_filters_path(account_id) <> "/#{filter_id}", [])
  end

  def update_syn_protection_filter(client, account_id, filter_id, params) when is_map(params) do
    patch(client, syn_filters_path(account_id) <> "/#{filter_id}", params)
  end

  def delete_syn_protection_filter(client, account_id, filter_id) do
    delete(client, syn_filters_path(account_id) <> "/#{filter_id}", %{})
  end

  ## SYN protection rules

  def list_syn_protection_rules(client, account_id, opts \\ []) do
    get(client, syn_rules_path(account_id), opts)
  end

  def create_syn_protection_rule(client, account_id, params) when is_map(params) do
    post(client, syn_rules_path(account_id), params)
  end

  def delete_syn_protection_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, syn_rules_path(account_id), params)
  end

  def get_syn_protection_rule(client, account_id, rule_id) do
    get(client, syn_rules_path(account_id) <> "/#{rule_id}", [])
  end

  def update_syn_protection_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, syn_rules_path(account_id) <> "/#{rule_id}", params)
  end

  def delete_syn_protection_rule(client, account_id, rule_id) do
    delete(client, syn_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## TCP flow protection filters

  def list_tcp_flow_filters(client, account_id, opts \\ []) do
    get(client, tcp_flow_filters_path(account_id), opts)
  end

  def create_tcp_flow_filter(client, account_id, params) when is_map(params) do
    post(client, tcp_flow_filters_path(account_id), params)
  end

  def delete_tcp_flow_filters(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, tcp_flow_filters_path(account_id), params)
  end

  def get_tcp_flow_filter(client, account_id, filter_id) do
    get(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", [])
  end

  def update_tcp_flow_filter(client, account_id, filter_id, params) when is_map(params) do
    patch(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", params)
  end

  def delete_tcp_flow_filter(client, account_id, filter_id) do
    delete(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", %{})
  end

  ## TCP flow protection rules

  def list_tcp_flow_rules(client, account_id, opts \\ []) do
    get(client, tcp_flow_rules_path(account_id), opts)
  end

  def create_tcp_flow_rule(client, account_id, params) when is_map(params) do
    post(client, tcp_flow_rules_path(account_id), params)
  end

  def delete_tcp_flow_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, tcp_flow_rules_path(account_id), params)
  end

  def get_tcp_flow_rule(client, account_id, rule_id) do
    get(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", [])
  end

  def update_tcp_flow_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", params)
  end

  def delete_tcp_flow_rule(client, account_id, rule_id) do
    delete(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## Protection status

  def get_protection_status(client, account_id) do
    get(client, protection_status_path(account_id), [])
  end

  def update_protection_status(client, account_id, params) when is_map(params) do
    patch(client, protection_status_path(account_id), params)
  end

  ## Helpers

  defp dns_rules_path(account_id),
    do: "/accounts/#{account_id}/magic/advanced_dns_protection/configs/dns_protection/rules"

  defp tcp_base(account_id),
    do: "/accounts/#{account_id}/magic/advanced_tcp_protection/configs"

  defp allowlist_path(account_id), do: tcp_base(account_id) <> "/allowlist"
  defp prefixes_path(account_id), do: tcp_base(account_id) <> "/prefixes"
  defp syn_filters_path(account_id), do: tcp_base(account_id) <> "/syn_protection/filters"
  defp syn_rules_path(account_id), do: tcp_base(account_id) <> "/syn_protection/rules"

  defp tcp_flow_filters_path(account_id),
    do: tcp_base(account_id) <> "/tcp_flow_protection/filters"

  defp tcp_flow_rules_path(account_id),
    do: tcp_base(account_id) <> "/tcp_flow_protection/rules"

  defp protection_status_path(account_id),
    do: tcp_base(account_id) <> "/tcp_protection_status"

  defp get(client, url, opts) do
    c(client)
    |> Tesla.get(with_query(url, opts))
    |> handle_response()
  end

  defp post(client, url, params) do
    c(client)
    |> Tesla.post(url, params)
    |> handle_response()
  end

  defp patch(client, url, params) do
    c(client)
    |> Tesla.patch(url, params)
    |> handle_response()
  end

  defp delete(client, url, params) do
    c(client)
    |> Tesla.delete(url, body: params)
    |> handle_response()
  end

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
