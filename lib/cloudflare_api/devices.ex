defmodule CloudflareApi.Devices do
  @moduledoc ~S"""
  Wraps the Workers Devices endpoints (list devices, device settings policies,
  split tunnel lists, override codes, certificates, etc.).
  """

  def list(client, account_id) do
    get(client, "/accounts/#{account_id}/devices")
  end

  def list_policies(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policies")
  end

  def get_default_policy(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy")
  end

  def update_default_policy(client, account_id, params) when is_map(params) do
    patch(client, "/accounts/#{account_id}/devices/policy", params)
  end

  def create_policy(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/policy", params)
  end

  def delete_policy(client, account_id, policy_id) do
    delete(client, "/accounts/#{account_id}/devices/policy/#{policy_id}", %{})
  end

  def get_policy(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}")
  end

  def update_policy(client, account_id, policy_id, params) when is_map(params) do
    patch(client, "/accounts/#{account_id}/devices/policy/#{policy_id}", params)
  end

  def split_tunnel_exclude(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/exclude")
  end

  def set_split_tunnel_exclude(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/exclude", params)
  end

  def split_tunnel_include(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/include")
  end

  def set_split_tunnel_include(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/include", params)
  end

  def fallback_domains(client, account_id) do
    get(client, "/accounts/#{account_id}/devices/policy/fallback_domains")
  end

  def set_fallback_domains(client, account_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/fallback_domains", params)
  end

  def policy_split_tunnel_exclude(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/exclude")
  end

  def set_policy_split_tunnel_exclude(client, account_id, policy_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/exclude", params)
  end

  def policy_split_tunnel_include(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/include")
  end

  def set_policy_split_tunnel_include(client, account_id, policy_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/include", params)
  end

  def policy_fallback_domains(client, account_id, policy_id) do
    get(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/fallback_domains")
  end

  def set_policy_fallback_domains(client, account_id, policy_id, params) when is_map(params) do
    put(client, "/accounts/#{account_id}/devices/policy/#{policy_id}/fallback_domains", params)
  end

  def revoke(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/revoke", params)
  end

  def unrevoke(client, account_id, params) when is_map(params) do
    post(client, "/accounts/#{account_id}/devices/unrevoke", params)
  end

  def device(client, account_id, device_id) do
    get(client, "/accounts/#{account_id}/devices/#{device_id}")
  end

  def override_codes(client, account_id, device_id) do
    get(client, "/accounts/#{account_id}/devices/#{device_id}/override_codes")
  end

  def certificate_status(client, zone_id) do
    get(client, "/zones/#{zone_id}/devices/policy/certificates")
  end

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
