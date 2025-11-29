defmodule CloudflareApi.ZeroTrustAccounts do
  @moduledoc ~S"""
  Zero Trust account-level helpers:
  - Device settings (`/accounts/:account_id/devices/settings`)
  - Account info/config/logging (`/accounts/:account_id/gateway`).
  """

  ## Device Settings

  @doc ~S"""
  Get device settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.get_device_settings(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_device_settings(client, account_id) do
    c(client)
    |> Tesla.get(device_settings_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete device settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.delete_device_settings(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_device_settings(client, account_id) do
    c(client)
    |> Tesla.delete(device_settings_path(account_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Patch device settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.patch_device_settings(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_device_settings(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(device_settings_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update device settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.update_device_settings(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_device_settings(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(device_settings_path(account_id), params)
    |> handle_response()
  end

  ## Gateway Account Info

  @doc ~S"""
  Get account for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.get_account(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_account(client, account_id) do
    c(client)
    |> Tesla.get(account_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create account for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.create_account(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_account(client, account_id, params \\ %{}) do
    c(client)
    |> Tesla.post(account_path(account_id), params)
    |> handle_response()
  end

  ## Gateway Configuration

  @doc ~S"""
  Get configuration for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.get_configuration(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_configuration(client, account_id) do
    c(client)
    |> Tesla.get(configuration_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch configuration for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.patch_configuration(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_configuration(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(configuration_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update configuration for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.update_configuration(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_configuration(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(configuration_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get custom certificate configuration for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.get_custom_certificate_configuration(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_custom_certificate_configuration(client, account_id) do
    c(client)
    |> Tesla.get(configuration_path(account_id) <> "/custom_certificate")
    |> handle_response()
  end

  ## Logging Settings

  @doc ~S"""
  Get logging settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.get_logging_settings(client, "account_id")
      {:ok, %{"id" => "example"}}

  """

  def get_logging_settings(client, account_id) do
    c(client)
    |> Tesla.get(logging_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Update logging settings for zero trust accounts.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZeroTrustAccounts.update_logging_settings(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_logging_settings(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(logging_path(account_id), params)
    |> handle_response()
  end

  defp device_settings_path(account_id), do: "/accounts/#{account_id}/devices/settings"
  defp account_path(account_id), do: "/accounts/#{account_id}/gateway"
  defp configuration_path(account_id), do: account_path(account_id) <> "/configuration"
  defp logging_path(account_id), do: account_path(account_id) <> "/logging"

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
