defmodule CloudflareApi.AccountCustomNameservers do
  @moduledoc ~S"""
  Manage account-level custom nameservers and zone usage metadata.
  """

  @doc ~S"""
  List account custom nameservers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountCustomNameservers.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    c(client) |> Tesla.get(base_path(account_id)) |> handle_response()
  end

  @doc ~S"""
  Create account custom nameservers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountCustomNameservers.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client) |> Tesla.post(base_path(account_id), params) |> handle_response()
  end

  @doc ~S"""
  Delete account custom nameservers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountCustomNameservers.delete(client, "account_id", "custom_ns_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, custom_ns_id) do
    c(client)
    |> Tesla.delete(base_path(account_id) <> "/#{custom_ns_id}", body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Zone usage for account custom nameservers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountCustomNameservers.zone_usage(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def zone_usage(client, zone_id) do
    c(client) |> Tesla.get(zone_path(zone_id)) |> handle_response()
  end

  @doc ~S"""
  Update zone usage for account custom nameservers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.AccountCustomNameservers.update_zone_usage(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_zone_usage(client, zone_id, params) when is_map(params) do
    c(client) |> Tesla.put(zone_path(zone_id), params) |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/custom_ns"
  defp zone_path(zone_id), do: "/zones/#{zone_id}/custom_ns"

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
