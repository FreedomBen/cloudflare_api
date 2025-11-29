defmodule CloudflareApi.EmailRoutingSettings do
  @moduledoc ~S"""
  Email Routing settings helpers under `/zones/:zone_id/email/routing`.
  """

  @doc ~S"""
  Get settings for email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.get_settings(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_settings(client, zone_id) do
    request(client, :get, base(zone_id))
  end

  @doc ~S"""
  Enable email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.enable(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def enable(client, zone_id) do
    request(client, :post, base(zone_id) <> "/enable", %{})
  end

  @doc ~S"""
  Disable email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.disable(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def disable(client, zone_id) do
    request(client, :post, base(zone_id) <> "/disable", %{})
  end

  @doc ~S"""
  Dns settings for email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.dns_settings(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def dns_settings(client, zone_id) do
    request(client, :get, base(zone_id) <> "/dns")
  end

  @doc ~S"""
  Enable dns for email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.enable_dns(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def enable_dns(client, zone_id) do
    request(client, :post, base(zone_id) <> "/dns", %{})
  end

  @doc ~S"""
  Disable dns for email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.disable_dns(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def disable_dns(client, zone_id) do
    request(client, :delete, base(zone_id) <> "/dns", %{})
  end

  @doc ~S"""
  Unlock dns for email routing settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.EmailRoutingSettings.unlock_dns(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def unlock_dns(client, zone_id, params) when is_map(params) do
    request(client, :patch, base(zone_id) <> "/dns", params)
  end

  defp base(zone_id), do: "/zones/#{zone_id}/email/routing"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:post, nil} -> Tesla.post(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:patch, %{} = params} -> Tesla.patch(client, url, params)
      end

    handle_response(result)
  end

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
