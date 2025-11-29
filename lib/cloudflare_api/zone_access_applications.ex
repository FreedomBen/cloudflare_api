defmodule CloudflareApi.ZoneAccessApplications do
  @moduledoc ~S"""
  Manage Access applications scoped to a zone (`/zones/:zone_id/access/apps`).
  """

  @doc ~S"""
  List zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.list(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Create zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.create(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.get(client, "zone_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, zone_id, app_id) do
    c(client)
    |> Tesla.get(app_path(zone_id, app_id))
    |> handle_response()
  end

  @doc ~S"""
  Update zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.update(client, "zone_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(app_path(zone_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.delete(client, "zone_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, zone_id, app_id) do
    c(client)
    |> Tesla.delete(app_path(zone_id, app_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Patch settings for zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.patch_settings(client, "zone_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_settings(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Put settings for zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.put_settings(client, "zone_id", "app_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def put_settings(client, zone_id, app_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id, app_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Test policies for zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.test_policies(client, "zone_id", "app_id", [])
      {:ok, %{"id" => "example"}}

  """

  def test_policies(client, zone_id, app_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(test_path(zone_id, app_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Revoke tokens for zone access applications.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneAccessApplications.revoke_tokens(client, "zone_id", "app_id")
      {:ok, %{"id" => "example"}}

  """

  def revoke_tokens(client, zone_id, app_id) do
    c(client)
    |> Tesla.post(revoke_path(zone_id, app_id), %{})
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/access/apps"
  defp app_path(zone_id, app_id), do: base_path(zone_id) <> "/#{app_id}"
  defp settings_path(zone_id, app_id), do: app_path(zone_id, app_id) <> "/settings"

  defp test_path(zone_id, app_id),
    do: app_path(zone_id, app_id) <> "/user_policy_checks"

  defp revoke_path(zone_id, app_id), do: app_path(zone_id, app_id) <> "/revoke_tokens"

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
