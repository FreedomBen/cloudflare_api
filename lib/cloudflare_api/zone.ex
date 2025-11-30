defmodule CloudflareApi.Zone do
  @moduledoc ~S"""
  Makes a struct and convenience functions around a Cloudflare Zone object.

  See Cloudflare docs:  https://api.cloudflare.com/#zone-properties
  """

  use CloudflareApi.Typespecs

  alias CloudflareApi.Utils

  @enforce_keys [:id]
  defstruct [
    :id,
    :name,
    :development_mode,
    :original_name_servers,
    :original_registrar,
    :original_dnshost,
    :created_on,
    :modified_on,
    :activated_on,
    :owner,
    :account,
    :permissions,
    :plan,
    :plan_pending,
    :status,
    :paused,
    :type,
    :name_servers
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t() | nil,
          development_mode: boolean() | nil,
          original_name_servers: list(String.t()) | nil,
          original_registrar: String.t() | nil,
          original_dnshost: String.t() | nil,
          created_on: String.t() | nil,
          modified_on: String.t() | nil,
          activated_on: String.t() | nil,
          owner: map() | nil,
          account: map() | nil,
          permissions: list(String.t()) | nil,
          plan: map() | nil,
          plan_pending: map() | nil,
          status: String.t() | nil,
          paused: boolean() | nil,
          type: String.t() | nil,
          name_servers: list(String.t()) | nil
        }

  @doc ~S"""
  Build the Cloudflare DNS records URL for a given zone.

  This is mostly useful for diagnostics and mirrors the REST endpoint used to
  manage DNS records under a zone.
  """
  def cf_url(zone) do
    "https://api.cloudflare.com/client/v4/zones/#{zone.zone_id}/dns_records"
  end

  @doc ~S"""
  Convert a `CloudflareApi.Zone` struct into a plain map.

  Internally this delegates to `CloudflareApi.Utils.struct_to_map/2` so that
  the resulting map is suitable for JSON encoding.
  """
  @spec to_cf_json(t()) :: map()
  def to_cf_json(zone) do
    Utils.struct_to_map(zone)
  end

  @doc ~S"""
  Build a `CloudflareApi.Zone` struct from a Cloudflare response map.

  The input can use either string keys (as returned directly by the API) or
  atom keys. Keys are normalized to atoms before the struct is constructed.
  """
  @spec from_cf_json(map() | struct()) :: t()
  def from_cf_json(zone) do
    zone
    |> normalize_keys()
    |> then(&struct(__MODULE__, &1))
  end

  defp normalize_keys(%{} = zone) do
    case Map.keys(zone) do
      [] ->
        zone

      [key | _] when is_binary(key) ->
        Utils.map_string_keys_to_atoms(zone)

      _ ->
        zone
    end
  end
end
