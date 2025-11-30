defmodule CloudflareApi.ZoneSettings do
  @moduledoc ~S"""
  General zone settings helpers for `/zones/:zone_id/settings`.
  """

  use CloudflareApi.Typespecs

  ## Bulk settings

  @doc ~S"""
  Get all for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_all(client, "zone_id")
      {:ok, [%{"id" => "example"}]}

  """

  def get_all(client, zone_id) do
    c(client)
    |> Tesla.get(settings_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update all for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.update_all(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_all(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id), params)
    |> handle_response()
  end

  ## Individual setting helpers

  @doc ~S"""
  Get setting for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_setting(client, "zone_id", "setting_id")
      {:ok, %{"id" => "example"}}

  """

  def get_setting(client, zone_id, setting_id) do
    c(client)
    |> Tesla.get(setting_path(zone_id, setting_id))
    |> handle_response()
  end

  @doc ~S"""
  Update setting for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.update_setting(client, "zone_id", "setting_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_setting(client, zone_id, setting_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(setting_path(zone_id, setting_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get aegis for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_aegis(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_aegis(client, zone_id), do: get_setting(client, zone_id, "aegis")

  @doc ~S"""
  Patch aegis for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_aegis(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_aegis(client, zone_id, params), do: update_setting(client, zone_id, "aegis", params)

  @doc ~S"""
  Get fonts for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_fonts(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_fonts(client, zone_id), do: get_setting(client, zone_id, "fonts")

  @doc ~S"""
  Patch fonts for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_fonts(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_fonts(client, zone_id, params),
    do: update_setting(client, zone_id, "fonts", params)

  @doc ~S"""
  Get origin h2 max streams for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_origin_h2_max_streams(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_origin_h2_max_streams(client, zone_id),
    do: get_setting(client, zone_id, "origin_h2_max_streams")

  @doc ~S"""
  Patch origin h2 max streams for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_origin_h2_max_streams(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_origin_h2_max_streams(client, zone_id, params),
    do: update_setting(client, zone_id, "origin_h2_max_streams", params)

  @doc ~S"""
  Get origin max http version for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_origin_max_http_version(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_origin_max_http_version(client, zone_id),
    do: get_setting(client, zone_id, "origin_max_http_version")

  @doc ~S"""
  Patch origin max http version for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_origin_max_http_version(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_origin_max_http_version(client, zone_id, params),
    do: update_setting(client, zone_id, "origin_max_http_version", params)

  @doc ~S"""
  Get speed brain for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_speed_brain(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_speed_brain(client, zone_id), do: get_setting(client, zone_id, "speed_brain")

  @doc ~S"""
  Patch speed brain for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_speed_brain(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_speed_brain(client, zone_id, params),
    do: update_setting(client, zone_id, "speed_brain", params)

  @doc ~S"""
  Get ssl automatic mode for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.get_ssl_automatic_mode(client, "zone_id")
      {:ok, %{"id" => "example"}}

  """

  def get_ssl_automatic_mode(client, zone_id),
    do: get_setting(client, zone_id, "ssl_automatic_mode")

  @doc ~S"""
  Patch ssl automatic mode for zone settings.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.ZoneSettings.patch_ssl_automatic_mode(client, "zone_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def patch_ssl_automatic_mode(client, zone_id, params),
    do: update_setting(client, zone_id, "ssl_automatic_mode", params)

  defp settings_path(zone_id), do: "/zones/#{zone_id}/settings"
  defp setting_path(zone_id, setting_id), do: settings_path(zone_id) <> "/#{setting_id}"

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
