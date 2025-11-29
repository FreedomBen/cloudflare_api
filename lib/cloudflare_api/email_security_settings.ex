defmodule CloudflareApi.EmailSecuritySettings do
  @moduledoc ~S"""
  Manage Email Security settings (`/accounts/:account_id/email-security/settings`).
  """

  def list_allow_policies(client, account_id, opts \\ []) do
    get(client, account_id, "/allow_policies" <> query(opts))
  end

  def create_allow_policy(client, account_id, params) when is_map(params) do
    post(client, account_id, "/allow_policies", params)
  end

  def batch_allow_policies(client, account_id, params) when is_map(params) do
    post(client, account_id, "/allow_policies/batch", params)
  end

  def get_allow_policy(client, account_id, policy_id) do
    get(client, account_id, "/allow_policies/#{policy_id}")
  end

  def update_allow_policy(client, account_id, policy_id, params) when is_map(params) do
    patch(client, account_id, "/allow_policies/#{policy_id}", params)
  end

  def delete_allow_policy(client, account_id, policy_id) do
    delete(client, account_id, "/allow_policies/#{policy_id}", %{})
  end

  def list_blocked_senders(client, account_id, opts \\ []) do
    get(client, account_id, "/block_senders" <> query(opts))
  end

  def create_blocked_sender(client, account_id, params) when is_map(params) do
    post(client, account_id, "/block_senders", params)
  end

  def batch_blocked_senders(client, account_id, params) when is_map(params) do
    post(client, account_id, "/block_senders/batch", params)
  end

  def get_blocked_sender(client, account_id, pattern_id) do
    get(client, account_id, "/block_senders/#{pattern_id}")
  end

  def update_blocked_sender(client, account_id, pattern_id, params) when is_map(params) do
    patch(client, account_id, "/block_senders/#{pattern_id}", params)
  end

  def delete_blocked_sender(client, account_id, pattern_id) do
    delete(client, account_id, "/block_senders/#{pattern_id}", %{})
  end

  def list_domains(client, account_id, opts \\ []) do
    get(client, account_id, "/domains" <> query(opts))
  end

  def get_domain(client, account_id, domain_id) do
    get(client, account_id, "/domains/#{domain_id}")
  end

  def update_domain(client, account_id, domain_id, params) when is_map(params) do
    patch(client, account_id, "/domains/#{domain_id}", params)
  end

  def delete_domain(client, account_id, domain_id) do
    delete(client, account_id, "/domains/#{domain_id}", %{})
  end

  def delete_domains(client, account_id, params) when is_map(params) do
    delete(client, account_id, "/domains", params)
  end

  def list_display_names(client, account_id, opts \\ []) do
    get(client, account_id, "/impersonation_registry" <> query(opts))
  end

  def create_display_name(client, account_id, params) when is_map(params) do
    post(client, account_id, "/impersonation_registry", params)
  end

  def get_display_name(client, account_id, display_name_id) do
    get(client, account_id, "/impersonation_registry/#{display_name_id}")
  end

  def update_display_name(client, account_id, display_name_id, params) when is_map(params) do
    patch(client, account_id, "/impersonation_registry/#{display_name_id}", params)
  end

  def delete_display_name(client, account_id, display_name_id) do
    delete(client, account_id, "/impersonation_registry/#{display_name_id}", %{})
  end

  def batch_sending_domain_restrictions(client, account_id, params) when is_map(params) do
    post(client, account_id, "/sending_domain_restrictions/batch", params)
  end

  def list_trusted_domains(client, account_id, opts \\ []) do
    get(client, account_id, "/trusted_domains" <> query(opts))
  end

  def create_trusted_domain(client, account_id, params) when is_map(params) do
    post(client, account_id, "/trusted_domains", params)
  end

  def batch_trusted_domains(client, account_id, params) when is_map(params) do
    post(client, account_id, "/trusted_domains/batch", params)
  end

  def get_trusted_domain(client, account_id, trusted_domain_id) do
    get(client, account_id, "/trusted_domains/#{trusted_domain_id}")
  end

  def update_trusted_domain(client, account_id, trusted_domain_id, params) when is_map(params) do
    patch(client, account_id, "/trusted_domains/#{trusted_domain_id}", params)
  end

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
