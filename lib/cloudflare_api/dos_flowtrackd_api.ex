defmodule CloudflareApi.DosFlowtrackdApi do
  @moduledoc ~S"""
  Configure Magic Advanced DDoS (Flowtrackd) protections for DNS and TCP.
  """

  use CloudflareApi.Typespecs

  ## DNS protection rules

  @doc ~S"""
  List dns protection rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_dns_protection_rules(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_dns_protection_rules(client, account_id, opts \\ []) do
    get(client, dns_rules_path(account_id), opts)
  end

  @doc ~S"""
  Create dns protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_dns_protection_rule(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_dns_protection_rule(client, account_id, params) when is_map(params) do
    post(client, dns_rules_path(account_id), params)
  end

  @doc ~S"""
  Delete dns protection rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_dns_protection_rules(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_dns_protection_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, dns_rules_path(account_id), params)
  end

  @doc ~S"""
  Get dns protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_dns_protection_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def get_dns_protection_rule(client, account_id, rule_id) do
    get(client, dns_rules_path(account_id) <> "/#{rule_id}", [])
  end

  @doc ~S"""
  Update dns protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_dns_protection_rule(client, "account_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_dns_protection_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, dns_rules_path(account_id) <> "/#{rule_id}", params)
  end

  @doc ~S"""
  Delete dns protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_dns_protection_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_dns_protection_rule(client, account_id, rule_id) do
    delete(client, dns_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## Allowlist prefixes

  @doc ~S"""
  List allowlist prefixes for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_allowlist_prefixes(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_allowlist_prefixes(client, account_id, opts \\ []) do
    get(client, allowlist_path(account_id), opts)
  end

  @doc ~S"""
  Create allowlist prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_allowlist_prefix(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_allowlist_prefix(client, account_id, params) when is_map(params) do
    post(client, allowlist_path(account_id), params)
  end

  @doc ~S"""
  Delete allowlist prefixes for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_allowlist_prefixes(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_allowlist_prefixes(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, allowlist_path(account_id), params)
  end

  @doc ~S"""
  Get allowlist prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_allowlist_prefix(client, "account_id", "prefix_id")
      {:ok, [%{"id" => "example"}]}

  """

  def get_allowlist_prefix(client, account_id, prefix_id) do
    get(client, allowlist_path(account_id) <> "/#{prefix_id}", [])
  end

  @doc ~S"""
  Update allowlist prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_allowlist_prefix(client, "account_id", "prefix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_allowlist_prefix(client, account_id, prefix_id, params) when is_map(params) do
    patch(client, allowlist_path(account_id) <> "/#{prefix_id}", params)
  end

  @doc ~S"""
  Delete allowlist prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_allowlist_prefix(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_allowlist_prefix(client, account_id, prefix_id) do
    delete(client, allowlist_path(account_id) <> "/#{prefix_id}", %{})
  end

  ## Advanced TCP prefixes

  @doc ~S"""
  List prefixes for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_prefixes(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_prefixes(client, account_id, opts \\ []) do
    get(client, prefixes_path(account_id), opts)
  end

  @doc ~S"""
  Create prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_prefix(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_prefix(client, account_id, params) when is_map(params) do
    post(client, prefixes_path(account_id), params)
  end

  @doc ~S"""
  Bulk create prefixes for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.bulk_create_prefixes(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def bulk_create_prefixes(client, account_id, params) when is_map(params) do
    post(client, prefixes_path(account_id) <> "/bulk", params)
  end

  @doc ~S"""
  Delete prefixes for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_prefixes(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_prefixes(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, prefixes_path(account_id), params)
  end

  @doc ~S"""
  Get prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_prefix(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def get_prefix(client, account_id, prefix_id) do
    get(client, prefixes_path(account_id) <> "/#{prefix_id}", [])
  end

  @doc ~S"""
  Update prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_prefix(client, "account_id", "prefix_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_prefix(client, account_id, prefix_id, params) when is_map(params) do
    patch(client, prefixes_path(account_id) <> "/#{prefix_id}", params)
  end

  @doc ~S"""
  Delete prefix for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_prefix(client, "account_id", "prefix_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_prefix(client, account_id, prefix_id) do
    delete(client, prefixes_path(account_id) <> "/#{prefix_id}", %{})
  end

  ## SYN protection filters

  @doc ~S"""
  List syn protection filters for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_syn_protection_filters(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_syn_protection_filters(client, account_id, opts \\ []) do
    get(client, syn_filters_path(account_id), opts)
  end

  @doc ~S"""
  Create syn protection filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_syn_protection_filter(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_syn_protection_filter(client, account_id, params) when is_map(params) do
    post(client, syn_filters_path(account_id), params)
  end

  @doc ~S"""
  Delete syn protection filters for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_syn_protection_filters(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_syn_protection_filters(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, syn_filters_path(account_id), params)
  end

  @doc ~S"""
  Get syn protection filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_syn_protection_filter(client, "account_id", "filter_id")
      {:ok, %{"id" => "example"}}

  """

  def get_syn_protection_filter(client, account_id, filter_id) do
    get(client, syn_filters_path(account_id) <> "/#{filter_id}", [])
  end

  @doc ~S"""
  Update syn protection filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_syn_protection_filter(client, "account_id", "filter_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_syn_protection_filter(client, account_id, filter_id, params) when is_map(params) do
    patch(client, syn_filters_path(account_id) <> "/#{filter_id}", params)
  end

  @doc ~S"""
  Delete syn protection filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_syn_protection_filter(client, "account_id", "filter_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_syn_protection_filter(client, account_id, filter_id) do
    delete(client, syn_filters_path(account_id) <> "/#{filter_id}", %{})
  end

  ## SYN protection rules

  @doc ~S"""
  List syn protection rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_syn_protection_rules(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_syn_protection_rules(client, account_id, opts \\ []) do
    get(client, syn_rules_path(account_id), opts)
  end

  @doc ~S"""
  Create syn protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_syn_protection_rule(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_syn_protection_rule(client, account_id, params) when is_map(params) do
    post(client, syn_rules_path(account_id), params)
  end

  @doc ~S"""
  Delete syn protection rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_syn_protection_rules(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_syn_protection_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, syn_rules_path(account_id), params)
  end

  @doc ~S"""
  Get syn protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_syn_protection_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def get_syn_protection_rule(client, account_id, rule_id) do
    get(client, syn_rules_path(account_id) <> "/#{rule_id}", [])
  end

  @doc ~S"""
  Update syn protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_syn_protection_rule(client, "account_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_syn_protection_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, syn_rules_path(account_id) <> "/#{rule_id}", params)
  end

  @doc ~S"""
  Delete syn protection rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_syn_protection_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_syn_protection_rule(client, account_id, rule_id) do
    delete(client, syn_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## TCP flow protection filters

  @doc ~S"""
  List tcp flow filters for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_tcp_flow_filters(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_tcp_flow_filters(client, account_id, opts \\ []) do
    get(client, tcp_flow_filters_path(account_id), opts)
  end

  @doc ~S"""
  Create tcp flow filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_tcp_flow_filter(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_tcp_flow_filter(client, account_id, params) when is_map(params) do
    post(client, tcp_flow_filters_path(account_id), params)
  end

  @doc ~S"""
  Delete tcp flow filters for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_tcp_flow_filters(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_tcp_flow_filters(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, tcp_flow_filters_path(account_id), params)
  end

  @doc ~S"""
  Get tcp flow filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_tcp_flow_filter(client, "account_id", "filter_id")
      {:ok, %{"id" => "example"}}

  """

  def get_tcp_flow_filter(client, account_id, filter_id) do
    get(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", [])
  end

  @doc ~S"""
  Update tcp flow filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_tcp_flow_filter(client, "account_id", "filter_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_tcp_flow_filter(client, account_id, filter_id, params) when is_map(params) do
    patch(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", params)
  end

  @doc ~S"""
  Delete tcp flow filter for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_tcp_flow_filter(client, "account_id", "filter_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_tcp_flow_filter(client, account_id, filter_id) do
    delete(client, tcp_flow_filters_path(account_id) <> "/#{filter_id}", %{})
  end

  ## TCP flow protection rules

  @doc ~S"""
  List tcp flow rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.list_tcp_flow_rules(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_tcp_flow_rules(client, account_id, opts \\ []) do
    get(client, tcp_flow_rules_path(account_id), opts)
  end

  @doc ~S"""
  Create tcp flow rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.create_tcp_flow_rule(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_tcp_flow_rule(client, account_id, params) when is_map(params) do
    post(client, tcp_flow_rules_path(account_id), params)
  end

  @doc ~S"""
  Delete tcp flow rules for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_tcp_flow_rules(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_tcp_flow_rules(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, tcp_flow_rules_path(account_id), params)
  end

  @doc ~S"""
  Get tcp flow rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_tcp_flow_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def get_tcp_flow_rule(client, account_id, rule_id) do
    get(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", [])
  end

  @doc ~S"""
  Update tcp flow rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_tcp_flow_rule(client, "account_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_tcp_flow_rule(client, account_id, rule_id, params) when is_map(params) do
    patch(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", params)
  end

  @doc ~S"""
  Delete tcp flow rule for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.delete_tcp_flow_rule(client, "account_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_tcp_flow_rule(client, account_id, rule_id) do
    delete(client, tcp_flow_rules_path(account_id) <> "/#{rule_id}", %{})
  end

  ## Protection status

  @doc ~S"""
  Get protection status for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.get_protection_status(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_protection_status(client, account_id) do
    get(client, protection_status_path(account_id), [])
  end

  @doc ~S"""
  Update protection status for dos flowtrackd api.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DosFlowtrackdApi.update_protection_status(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

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
