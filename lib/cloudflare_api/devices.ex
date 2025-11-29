defmodule CloudflareApi.Devices do
  @moduledoc ~S"""
  Wraps the Workers Devices endpoints (list devices, device settings policies,
  split tunnel lists, override codes, certificates, etc.).
  """

  @doc ~S"""
  List devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    get(client, "/accounts/#{account_id}/devices")
  end

  @doc ~S"""
  List policies for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.list_policies(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_policies(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policies")
  end

  @doc ~S"""
  Get default policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.get_default_policy(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_default_policy(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy")
  end

  @doc ~S"""
  Update default policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.update_default_policy(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_default_policy(client, account_id, params) when is_map(params) do
    patch(client, "/accounts/#{account_id}/devices/policy", params)
  end

  @doc ~S"""
  Create policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.create_policy(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_policy(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/policy", params)
  end

  @doc ~S"""
  Delete policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.delete_policy(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_policy(client, account_id, policy_id) do
    delete(client, "/accounts/#{account_id}/devices/policy/#{policy_id}", %{})
  end

  @doc ~S"""
  Get policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.get_policy(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def get_policy(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}")
  end

  @doc ~S"""
  Update policy for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.update_policy(client, "account_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_policy(client, account_id, policy_id, params) when is_map(params) do
    patch(client, "/accounts/#{account_id}/devices/policy/#{policy_id}", params)
  end

  @doc ~S"""
  Split tunnel exclude for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.split_tunnel_exclude(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def split_tunnel_exclude(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/exclude")
  end

  @doc ~S"""
  Set split tunnel exclude for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_split_tunnel_exclude(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_split_tunnel_exclude(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/exclude", params)
  end

  @doc ~S"""
  Split tunnel include for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.split_tunnel_include(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def split_tunnel_include(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/include")
  end

  @doc ~S"""
  Set split tunnel include for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_split_tunnel_include(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_split_tunnel_include(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/include", params)
  end

  @doc ~S"""
  Fallback domains for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.fallback_domains(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def fallback_domains(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/fallback_domains")
  end

  @doc ~S"""
  Set fallback domains for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_fallback_domains(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_fallback_domains(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/fallback_domains", params)
  end

  @doc ~S"""
  Policy split tunnel exclude for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.policy_split_tunnel_exclude(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def policy_split_tunnel_exclude(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/exclude")
  end

  @doc ~S"""
  Set policy split tunnel exclude for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_policy_split_tunnel_exclude(client, "account_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_policy_split_tunnel_exclude(client, account_id, policy_id, params)
      when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/exclude", params)
  end

  @doc ~S"""
  Policy split tunnel include for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.policy_split_tunnel_include(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def policy_split_tunnel_include(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/include")
  end

  @doc ~S"""
  Set policy split tunnel include for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_policy_split_tunnel_include(client, "account_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_policy_split_tunnel_include(client, account_id, policy_id, params)
      when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/include", params)
  end

  @doc ~S"""
  Policy fallback domains for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.policy_fallback_domains(client, "account_id", "policy_id")
      {:ok, %{"id" => "example"}}

  """

  def policy_fallback_domains(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/fallback_domains")
  end

  @doc ~S"""
  Set policy fallback domains for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.set_policy_fallback_domains(client, "account_id", "policy_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def set_policy_fallback_domains(client, account_id, policy_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/fallback_domains", params)
  end

  @doc ~S"""
  Revoke devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.revoke(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def revoke(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/revoke", params)
  end

  @doc ~S"""
  Unrevoke devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.unrevoke(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def unrevoke(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/unrevoke", params)
  end

  @doc ~S"""
  Device devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.device(client, "account_id", "device_id")
      {:ok, %{"id" => "example"}}

  """

  def device(client, account_id, device_id) do
    get(client, "/accounts/#{account_id}/devices/#{device_id}")
  end

  @doc ~S"""
  Override codes for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.override_codes(client, "account_id", "device_id")
      {:ok, %{"id" => "example"}}

  """

  def override_codes(client, account_id, device_id) do
    get(client, "/accounts/#{account_id}/devices/#{device_id}/override_codes")
  end

  @doc ~S"""
  Certificate status for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.certificate_status(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def certificate_status(client, zone_id) do
    get(client, "/zones/#{zone_id}/devices/policy/certificates")
  end

  @doc ~S"""
  Update certificate status for devices.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Devices.update_certificate_status(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_certificate_status(client, zone_id, params) when is_map(params) do
    patch(client, "/zones/#{zone_id}/devices/policy/certificates", params)
  end

  defp get(client, url), do: c(client) |> Tesla.get(url) |> handle()
  defp post(client, url, params), do: c(client) |> Tesla.post(url, params) |> handle()
  defp patch(client, url, params), do: c(client) |> Tesla.patch(url, params) |> handle()
  defp put(client, url, params), do: c(client) |> Tesla.put(url, params) |> handle()
  defp delete(client, url, params), do: c(client) |> Tesla.delete(url, body: params) |> handle()

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
