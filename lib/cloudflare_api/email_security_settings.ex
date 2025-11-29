defmodule CloudflareApi.EmailSecuritySettings do
  @moduledoc ~S"""
  Manage Email Security settings (`/accounts/:account_id/email-security/settings`).
  """

  @doc ~S"""
  List allow policies for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.list_allow_policies(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_allow_policies(client, account_id, opts \\ []) do
    get(client, account_id, "/allow_policies" <> query(opts))
  end

  @doc ~S"""
  Create allow policy for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.create_allow_policy(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_allow_policy(client, account_id, params) when is_map(params) do
    post(client, account_id, "/allow_policies", params)
  end

  @doc ~S"""
  Batch allow policies for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.batch_allow_policies(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def batch_allow_policies(client, account_id, params) when is_map(params) do
    post(client, account_id, "/allow_policies/batch", params)
  end

  @doc ~S"""
  Get allow policy for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.get_allow_policy(client, "account_id", "policy_id")
      {:ok, [%{"id" => "example"}]}

  """

  def get_allow_policy(client, account_id, policy_id) do
    get(client, account_id, "/allow_policies/#{policy_id}")
  end

  @doc ~S"""
  Update allow policy for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.update_allow_policy(client, "account_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_allow_policy(client, account_id, policy_id, params) when is_map(params) do
    patch(client, account_id, "/allow_policies/#{policy_id}", params)
  end

  @doc ~S"""
  Delete allow policy for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_allow_policy(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_allow_policy(client, account_id, policy_id) do
    delete(client, account_id, "/allow_policies/#{policy_id}", %{})
  end

  @doc ~S"""
  List blocked senders for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.list_blocked_senders(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_blocked_senders(client, account_id, opts \\ []) do
    get(client, account_id, "/block_senders" <> query(opts))
  end

  @doc ~S"""
  Create blocked sender for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.create_blocked_sender(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_blocked_sender(client, account_id, params) when is_map(params) do
    post(client, account_id, "/block_senders", params)
  end

  @doc ~S"""
  Batch blocked senders for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.batch_blocked_senders(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def batch_blocked_senders(client, account_id, params) when is_map(params) do
    post(client, account_id, "/block_senders/batch", params)
  end

  @doc ~S"""
  Get blocked sender for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.get_blocked_sender(client, "account_id", "pattern_id")
      {:ok, %{"id" => "example"}}

  """

  def get_blocked_sender(client, account_id, pattern_id) do
    get(client, account_id, "/block_senders/#{pattern_id}")
  end

  @doc ~S"""
  Update blocked sender for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.update_blocked_sender(client, "account_id", "pattern_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_blocked_sender(client, account_id, pattern_id, params) when is_map(params) do
    patch(client, account_id, "/block_senders/#{pattern_id}", params)
  end

  @doc ~S"""
  Delete blocked sender for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_blocked_sender(client, "account_id", "pattern_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_blocked_sender(client, account_id, pattern_id) do
    delete(client, account_id, "/block_senders/#{pattern_id}", %{})
  end

  @doc ~S"""
  List domains for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.list_domains(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_domains(client, account_id, opts \\ []) do
    get(client, account_id, "/domains" <> query(opts))
  end

  @doc ~S"""
  Get domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.get_domain(client, "account_id", "domain_id")
      {:ok, %{"id" => "example"}}

  """

  def get_domain(client, account_id, domain_id) do
    get(client, account_id, "/domains/#{domain_id}")
  end

  @doc ~S"""
  Update domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.update_domain(client, "account_id", "domain_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_domain(client, account_id, domain_id, params) when is_map(params) do
    patch(client, account_id, "/domains/#{domain_id}", params)
  end

  @doc ~S"""
  Delete domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_domain(client, "account_id", "domain_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_domain(client, account_id, domain_id) do
    delete(client, account_id, "/domains/#{domain_id}", %{})
  end

  @doc ~S"""
  Delete domains for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_domains(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_domains(client, account_id, params) when is_map(params) do
    delete(client, account_id, "/domains", params)
  end

  @doc ~S"""
  List display names for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.list_display_names(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_display_names(client, account_id, opts \\ []) do
    get(client, account_id, "/impersonation_registry" <> query(opts))
  end

  @doc ~S"""
  Create display name for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.create_display_name(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_display_name(client, account_id, params) when is_map(params) do
    post(client, account_id, "/impersonation_registry", params)
  end

  @doc ~S"""
  Get display name for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.get_display_name(client, "account_id", "display_name_id")
      {:ok, %{"id" => "example"}}

  """

  def get_display_name(client, account_id, display_name_id) do
    get(client, account_id, "/impersonation_registry/#{display_name_id}")
  end

  @doc ~S"""
  Update display name for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.update_display_name(client, "account_id", "display_name_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_display_name(client, account_id, display_name_id, params) when is_map(params) do
    patch(client, account_id, "/impersonation_registry/#{display_name_id}", params)
  end

  @doc ~S"""
  Delete display name for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_display_name(client, "account_id", "display_name_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_display_name(client, account_id, display_name_id) do
    delete(client, account_id, "/impersonation_registry/#{display_name_id}", %{})
  end

  @doc ~S"""
  Batch sending domain restrictions for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.batch_sending_domain_restrictions(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def batch_sending_domain_restrictions(client, account_id, params) when is_map(params) do
    post(client, account_id, "/sending_domain_restrictions/batch", params)
  end

  @doc ~S"""
  List trusted domains for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.list_trusted_domains(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_trusted_domains(client, account_id, opts \\ []) do
    get(client, account_id, "/trusted_domains" <> query(opts))
  end

  @doc ~S"""
  Create trusted domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.create_trusted_domain(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_trusted_domain(client, account_id, params) when is_map(params) do
    post(client, account_id, "/trusted_domains", params)
  end

  @doc ~S"""
  Batch trusted domains for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.batch_trusted_domains(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def batch_trusted_domains(client, account_id, params) when is_map(params) do
    post(client, account_id, "/trusted_domains/batch", params)
  end

  @doc ~S"""
  Get trusted domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.get_trusted_domain(client, "account_id", "trusted_domain_id")
      {:ok, %{"id" => "example"}}

  """

  def get_trusted_domain(client, account_id, trusted_domain_id) do
    get(client, account_id, "/trusted_domains/#{trusted_domain_id}")
  end

  @doc ~S"""
  Update trusted domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.update_trusted_domain(client, "account_id", "trusted_domain_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_trusted_domain(client, account_id, trusted_domain_id, params) when is_map(params) do
    patch(client, account_id, "/trusted_domains/#{trusted_domain_id}", params)
  end

  @doc ~S"""
  Delete trusted domain for email security settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailSecuritySettings.delete_trusted_domain(client, "account_id", "trusted_domain_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_trusted_domain(client, account_id, trusted_domain_id) do
    delete(client, account_id, "/trusted_domains/#{trusted_domain_id}", %{})
  end

  defp base(account_id), do: "/accounts/#{account_id}/email-security/settings"

  defp get(client, account_id, path) do
    c(client)
    |> Tesla.get(base(account_id) <> path)
    |> handle()
  end

  defp post(client, account_id, path, params) do
    c(client)
    |> Tesla.post(base(account_id) <> path, params)
    |> handle()
  end

  defp patch(client, account_id, path, params) do
    c(client)
    |> Tesla.patch(base(account_id) <> path, params)
    |> handle()
  end

  defp delete(client, account_id, path, params) do
    c(client)
    |> Tesla.delete(base(account_id) <> path, body: params)
    |> handle()
  end

  defp query([]), do: ""
  defp query(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
