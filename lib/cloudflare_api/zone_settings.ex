defmodule CloudflareApi.ZoneSettings do
  @moduledoc ~S"""
  General zone settings helpers for `/zones/:zone_id/settings`.
  """

  ## Bulk settings

  def get_all(client, zone_id) do
    c(client)
    |> Tesla.get(settings_path(zone_id))
    |> handle_response()
  end

  def update_all(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id), params)
    |> handle_response()
  end

  ## Individual setting helpers

  def get_setting(client, zone_id, setting_id) do
    c(client)
    |> Tesla.get(setting_path(zone_id, setting_id))
    |> handle_response()
  end

  def update_setting(client, zone_id, setting_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(setting_path(zone_id, setting_id), params)
    |> handle_response()
  end

  def get_aegis(client, zone_id), do: get_setting(client, zone_id, "aegis")
  def patch_aegis(client, zone_id, params), do: update_setting(client, zone_id, "aegis", params)

  def get_fonts(client, zone_id), do: get_setting(client, zone_id, "fonts")

  def patch_fonts(client, zone_id, params),
    do: update_setting(client, zone_id, "fonts", params)

  def get_origin_h2_max_streams(client, zone_id),
    do: get_setting(client, zone_id, "origin_h2_max_streams")

  def patch_origin_h2_max_streams(client, zone_id, params),
    do: update_setting(client, zone_id, "origin_h2_max_streams", params)

  def get_origin_max_http_version(client, zone_id),
    do: get_setting(client, zone_id, "origin_max_http_version")

  def patch_origin_max_http_version(client, zone_id, params),
    do: update_setting(client, zone_id, "origin_max_http_version", params)

  def get_speed_brain(client, zone_id), do: get_setting(client, zone_id, "speed_brain")

  def patch_speed_brain(client, zone_id, params),
    do: update_setting(client, zone_id, "speed_brain", params)

  def get_ssl_automatic_mode(client, zone_id),
    do: get_setting(client, zone_id, "ssl_automatic_mode")

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
