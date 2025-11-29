defmodule CloudflareApi.AccountRulesets do
  @moduledoc ~S"""
  Manage Rulesets at the account level (Ruleset Engine).
  """

  @doc ~S"""
  List account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    get(client, list_url(account_id, opts))
  end

  @doc ~S"""
  Create account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    post(client, base_path(account_id), params)
  end

  @doc ~S"""
  Get ruleset for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.get_ruleset(client, "account_id", "ruleset_id")
      {:ok, %{"id" => "example"}}

  """

  def get_ruleset(client, account_id, ruleset_id) do
    get(client, ruleset_path(account_id, ruleset_id))
  end

  @doc ~S"""
  Update ruleset for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.update_ruleset(client, "account_id", "ruleset_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_ruleset(client, account_id, ruleset_id, params) when is_map(params) do
    put(client, ruleset_path(account_id, ruleset_id), params)
  end

  @doc ~S"""
  Delete ruleset for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.delete_ruleset(client, "account_id", "ruleset_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_ruleset(client, account_id, ruleset_id) do
    delete(client, ruleset_path(account_id, ruleset_id))
  end

  @doc ~S"""
  Create rule for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.create_rule(client, "account_id", "ruleset_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_rule(client, account_id, ruleset_id, params) when is_map(params) do
    post(client, ruleset_path(account_id, ruleset_id) <> "/rules", params)
  end

  @doc ~S"""
  Update rule for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.update_rule(client, "account_id", "ruleset_id", "rule_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_rule(client, account_id, ruleset_id, rule_id, params) when is_map(params) do
    patch(client, ruleset_path(account_id, ruleset_id) <> "/rules/#{rule_id}", params)
  end

  @doc ~S"""
  Delete rule for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.delete_rule(client, "account_id", "ruleset_id", "rule_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_rule(client, account_id, ruleset_id, rule_id) do
    delete(client, ruleset_path(account_id, ruleset_id) <> "/rules/#{rule_id}")
  end

  @doc ~S"""
  List versions for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.list_versions(client, "account_id", "ruleset_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_versions(client, account_id, ruleset_id) do
    get(client, ruleset_path(account_id, ruleset_id) <> "/versions")
  end

  @doc ~S"""
  Get version for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.get_version(client, "account_id", "ruleset_id", "version_id")
      {:ok, %{"id" => "example"}}

  """

  def get_version(client, account_id, ruleset_id, version_id) do
    get(client, version_path(account_id, ruleset_id, version_id))
  end

  @doc ~S"""
  Delete version for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.delete_version(client, "account_id", "ruleset_id", "version_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_version(client, account_id, ruleset_id, version_id) do
    delete(client, version_path(account_id, ruleset_id, version_id))
  end

  @doc ~S"""
  List version rules by tag for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.list_version_rules_by_tag(client, "account_id", "ruleset_id", "version_id", "tag")
      {:ok, [%{"id" => "example"}]}

  """

  def list_version_rules_by_tag(client, account_id, ruleset_id, version_id, tag) do
    get(client, version_path(account_id, ruleset_id, version_id) <> "/by_tag/#{tag}")
  end

  @doc ~S"""
  Entrypoint account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.entrypoint(client, "account_id", "phase")
      {:ok, %{"id" => "example"}}

  """

  def entrypoint(client, account_id, phase) do
    get(client, entrypoint_path(account_id, phase))
  end

  @doc ~S"""
  Update entrypoint for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.update_entrypoint(client, "account_id", "phase", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_entrypoint(client, account_id, phase, params) when is_map(params) do
    put(client, entrypoint_path(account_id, phase), params)
  end

  @doc ~S"""
  List entrypoint versions for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.list_entrypoint_versions(client, "account_id", "phase")
      {:ok, [%{"id" => "example"}]}

  """

  def list_entrypoint_versions(client, account_id, phase) do
    get(client, entrypoint_path(account_id, phase) <> "/versions")
  end

  @doc ~S"""
  Get entrypoint version for account rulesets.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountRulesets.get_entrypoint_version(client, "account_id", "phase", "version_id")
      {:ok, %{"id" => "example"}}

  """

  def get_entrypoint_version(client, account_id, phase, version_id) do
    get(client, entrypoint_path(account_id, phase) <> "/versions/#{version_id}")
  end

  defp list_url(account_id, []), do: base_path(account_id)

  defp list_url(account_id, opts) do
    base_path(account_id) <> "?" <> CloudflareApi.uri_encode_opts(opts)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/rulesets"
  defp ruleset_path(account_id, ruleset_id), do: base_path(account_id) <> "/#{ruleset_id}"

  defp version_path(account_id, ruleset_id, version_id),
    do: ruleset_path(account_id, ruleset_id) <> "/versions/#{version_id}"

  defp entrypoint_path(account_id, phase),
    do: "/accounts/#{account_id}/rulesets/phases/#{phase}/entrypoint"

  defp get(client, url), do: c(client) |> Tesla.get(url) |> handle_response()
  defp post(client, url, body), do: c(client) |> Tesla.post(url, body) |> handle_response()
  defp put(client, url, body), do: c(client) |> Tesla.put(url, body) |> handle_response()
  defp patch(client, url, body), do: c(client) |> Tesla.patch(url, body) |> handle_response()
  defp delete(client, url), do: c(client) |> Tesla.delete(url, body: %{}) |> handle_response()

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
