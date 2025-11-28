defmodule CloudflareApi.ZoneTest do
  use ExUnit.Case, async: true

  alias CloudflareApi.Zone
  alias CloudflareApi.Utils

  test "to_cf_json/1 delegates to Utils.struct_to_map/1" do
    zone = %Zone{
      id: "zone-id",
      name: "example.com",
      development_mode: 0,
      original_name_servers: ["ns1", "ns2"],
      original_registrar: "reg",
      original_dnshost: "host",
      created_on: "now",
      modified_on: "later",
      activated_on: "now",
      owner: %{"id" => "owner"},
      account: %{"id" => "account"},
      permissions: ["read"],
      plan: %{"id" => "plan"},
      plan_pending: %{"id" => "plan-pending"},
      status: "active",
      paused: false,
      type: "full",
      name_servers: ["ns1", "ns2"]
    }

    map = Zone.to_cf_json(zone)

    assert map == Utils.struct_to_map(zone)
  end

  test "from_cf_json/1 accepts string-keyed map" do
    source = %{
      "zone_id" => "zone-id",
      "id" => "zone-id",
      "name" => "example.com"
    }

    zone = Zone.from_cf_json(source)

    assert %Zone{id: "zone-id", name: "example.com"} = zone
  end

  test "from_cf_json/1 accepts atom-keyed map" do
    source = %{
      zone_id: "zone-id",
      id: "zone-id",
      name: "example.com"
    }

    zone = Zone.from_cf_json(source)

    assert %Zone{id: "zone-id", name: "example.com"} = zone
  end
end

