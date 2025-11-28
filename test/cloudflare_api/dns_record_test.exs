defmodule CloudflareApi.DnsRecordTest do
  use ExUnit.Case, async: true

  doctest CloudflareApi.DnsRecord

  alias CloudflareApi.DnsRecord

  test "to_cf_json/1 maps struct fields to Cloudflare JSON" do
    record = %DnsRecord{
      id: "id",
      zone_id: "zone-id",
      zone_name: "example.com",
      hostname: "www.example.com",
      ip: "1.2.3.4",
      created_on: "now",
      type: :A,
      ttl: 120,
      proxied: true,
      proxiable: true,
      locked: false
    }

    json = DnsRecord.to_cf_json(record)

    assert json == %{
             type: :A,
             name: "www.example.com",
             content: "1.2.3.4",
             ttl: 120,
             proxied: true
           }
  end

  test "from_cf_json/1 handles string-keyed map" do
    source = %{
      "id" => "id",
      "zone_id" => "zone-id",
      "zone_name" => "example.com",
      "name" => "www.example.com",
      "content" => "1.2.3.4",
      "created_on" => "now",
      "type" => "A",
      "ttl" => 120,
      "proxied" => true,
      "proxiable" => true,
      "locked" => false
    }

    record = DnsRecord.from_cf_json(source)

    assert %DnsRecord{
             id: "id",
             zone_id: "zone-id",
             zone_name: "example.com",
             hostname: "www.example.com",
             ip: "1.2.3.4",
             created_on: "now",
             type: "A",
             ttl: 120,
             proxied: true,
             proxiable: true,
             locked: false
           } = record
  end

  test "from_cf_json/1 handles struct-like map with atom keys" do
    source = %{
      zone_id: "zone-id",
      zone_name: "example.com",
      id: "id",
      name: "www.example.com",
      content: "1.2.3.4",
      created_on: "now",
      type: "A",
      ttl: 120,
      proxied: true,
      proxiable: true,
      locked: false
    }

    record = DnsRecord.from_cf_json(source)

    assert %DnsRecord{zone_id: "zone-id", hostname: "www.example.com", ip: "1.2.3.4"} = record
  end
end
