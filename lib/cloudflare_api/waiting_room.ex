defmodule CloudflareApi.WaitingRoom do
  @moduledoc ~S"""
  Thin wrappers for Cloudflare Waiting Room APIs, covering account-level
  listings plus zone-level waiting rooms, events, rules, and settings.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List waiting rooms scoped to an account (`GET /accounts/:account_id/waiting_rooms`).

  Supports the `:page` and `:per_page` pagination options.
  """
  def list_account_waiting_rooms(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(account_waiting_rooms_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  List waiting rooms for a zone (`GET /zones/:zone_id/waiting_rooms`).

  Supports the `:page` and `:per_page` pagination options.
  """
  def list_zone_waiting_rooms(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(zone_waiting_rooms_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a waiting room (`POST /zones/:zone_id/waiting_rooms`).
  """
  def create_waiting_room(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(zone_waiting_rooms_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Render a waiting room custom page preview (`POST /zones/:zone_id/waiting_rooms/preview`).
  """
  def create_page_preview(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(preview_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch the zone-level Waiting Room settings (`GET /zones/:zone_id/waiting_rooms/settings`).
  """
  def get_settings(client, zone_id) do
    c(client)
    |> Tesla.get(settings_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch the zone-level Waiting Room settings (`PATCH /zones/:zone_id/waiting_rooms/settings`).
  """
  def patch_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace the zone-level Waiting Room settings (`PUT /zones/:zone_id/waiting_rooms/settings`).
  """
  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(settings_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a waiting room (`DELETE /zones/:zone_id/waiting_rooms/:waiting_room_id`).
  """
  def delete_waiting_room(client, zone_id, waiting_room_id) do
    c(client)
    |> Tesla.delete(waiting_room_path(zone_id, waiting_room_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Retrieve waiting room details (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id`).
  """
  def get_waiting_room(client, zone_id, waiting_room_id) do
    c(client)
    |> Tesla.get(waiting_room_path(zone_id, waiting_room_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch a waiting room (`PATCH /zones/:zone_id/waiting_rooms/:waiting_room_id`).
  """
  def patch_waiting_room(client, zone_id, waiting_room_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(waiting_room_path(zone_id, waiting_room_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace a waiting room definition (`PUT /zones/:zone_id/waiting_rooms/:waiting_room_id`).
  """
  def update_waiting_room(client, zone_id, waiting_room_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(waiting_room_path(zone_id, waiting_room_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List events for a waiting room (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id/events`).

  Supports the `:page` and `:per_page` pagination options.
  """
  def list_events(client, zone_id, waiting_room_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(events_path(zone_id, waiting_room_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an event (`POST /zones/:zone_id/waiting_rooms/:waiting_room_id/events`).
  """
  def create_event(client, zone_id, waiting_room_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(events_path(zone_id, waiting_room_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an event (`DELETE /zones/:zone_id/waiting_rooms/:waiting_room_id/events/:event_id`).
  """
  def delete_event(client, zone_id, waiting_room_id, event_id) do
    c(client)
    |> Tesla.delete(event_path(zone_id, waiting_room_id, event_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch event details (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id/events/:event_id`).
  """
  def get_event(client, zone_id, waiting_room_id, event_id) do
    c(client)
    |> Tesla.get(event_path(zone_id, waiting_room_id, event_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch an event (`PATCH /zones/:zone_id/waiting_rooms/:waiting_room_id/events/:event_id`).
  """
  def patch_event(client, zone_id, waiting_room_id, event_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(event_path(zone_id, waiting_room_id, event_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace an event definition (`PUT /zones/:zone_id/waiting_rooms/:waiting_room_id/events/:event_id`).
  """
  def update_event(client, zone_id, waiting_room_id, event_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(event_path(zone_id, waiting_room_id, event_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Preview the details for the active event (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id/events/:event_id/details`).
  """
  def preview_event_details(client, zone_id, waiting_room_id, event_id) do
    c(client)
    |> Tesla.get(event_details_path(zone_id, waiting_room_id, event_id))
    |> handle_response()
  end

  @doc ~S"""
  List Waiting Room rules (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id/rules`).
  """
  def list_rules(client, zone_id, waiting_room_id) do
    c(client)
    |> Tesla.get(rules_path(zone_id, waiting_room_id))
    |> handle_response()
  end

  @doc ~S"""
  Create a Waiting Room rule (`POST /zones/:zone_id/waiting_rooms/:waiting_room_id/rules`).
  """
  def create_rule(client, zone_id, waiting_room_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(rules_path(zone_id, waiting_room_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace all Waiting Room rules (`PUT /zones/:zone_id/waiting_rooms/:waiting_room_id/rules`).
  """
  def replace_rules(client, zone_id, waiting_room_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(rules_path(zone_id, waiting_room_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Waiting Room rule (`DELETE /zones/:zone_id/waiting_rooms/:waiting_room_id/rules/:rule_id`).
  """
  def delete_rule(client, zone_id, waiting_room_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, waiting_room_id, rule_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Patch a Waiting Room rule (`PATCH /zones/:zone_id/waiting_rooms/:waiting_room_id/rules/:rule_id`).
  """
  def patch_rule(client, zone_id, waiting_room_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(rule_path(zone_id, waiting_room_id, rule_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch the status for a waiting room (`GET /zones/:zone_id/waiting_rooms/:waiting_room_id/status`).
  """
  def get_status(client, zone_id, waiting_room_id) do
    c(client)
    |> Tesla.get(status_path(zone_id, waiting_room_id))
    |> handle_response()
  end

  defp account_waiting_rooms_path(account_id), do: "/accounts/#{account_id}/waiting_rooms"

  defp zone_waiting_rooms_path(zone_id), do: "/zones/#{zone_id}/waiting_rooms"

  defp waiting_room_path(zone_id, waiting_room_id),
    do: zone_waiting_rooms_path(zone_id) <> "/#{waiting_room_id}"

  defp events_path(zone_id, waiting_room_id),
    do: waiting_room_path(zone_id, waiting_room_id) <> "/events"

  defp event_path(zone_id, waiting_room_id, event_id),
    do: events_path(zone_id, waiting_room_id) <> "/#{event_id}"

  defp event_details_path(zone_id, waiting_room_id, event_id),
    do: event_path(zone_id, waiting_room_id, event_id) <> "/details"

  defp rules_path(zone_id, waiting_room_id),
    do: waiting_room_path(zone_id, waiting_room_id) <> "/rules"

  defp rule_path(zone_id, waiting_room_id, rule_id),
    do: rules_path(zone_id, waiting_room_id) <> "/#{rule_id}"

  defp status_path(zone_id, waiting_room_id),
    do: waiting_room_path(zone_id, waiting_room_id) <> "/status"

  defp settings_path(zone_id), do: zone_waiting_rooms_path(zone_id) <> "/settings"

  defp preview_path(zone_id), do: zone_waiting_rooms_path(zone_id) <> "/preview"

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
