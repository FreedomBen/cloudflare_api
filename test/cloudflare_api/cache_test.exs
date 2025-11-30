defmodule CloudflareApi.CacheTest do
  use ExUnit.Case
  doctest CloudflareApi.Cache

  alias CloudflareApi.{Cache, DnsRecord}

  @test_hostname "test.example.com"

  setup do
    Cache.flush()

    on_exit(fn ->
      Cache.flush()
    end)
  end

  describe "cache" do
    test "expired is hidden" do
      hostname = @test_hostname
      dns_record = dns_record_fixture(hostname)

      assert dns_record == Cache.add_or_update(dns_record)
      assert Cache.includes?(hostname)
      assert dns_record == Cache.get(hostname)

      assert :ok == Cache.expire(hostname)
      refute Cache.includes?(hostname)
      assert Cache.get(hostname) == nil
      assert Cache.get(hostname, :even_if_expired) == dns_record
      assert Cache.includes?(hostname, :even_if_expired)
    end

    test "includes, update, get, flush, dump, delete all work" do
      hn1 = "hostname1.example.com"
      hn2 = "hostname2.example.com"

      drf1 = dns_record_fixture(hn1)
      drf2 = dns_record_fixture(hn2)

      assert false == Cache.includes?(hn1)
      assert drf1 == Cache.add_or_update(drf1)

      assert true == Cache.includes?(hn1)
      assert drf1 == Cache.get(hn1)
      assert [drf1] == Cache.dump()
      assert :ok == Cache.flush()

      assert drf1 == Cache.add_or_update(hn1, drf1)
      assert drf2 == Cache.add_or_update(hn2, drf2)

      assert dump_res = Cache.dump_cache()
      assert true == Map.has_key?(dump_res.hostnames, hn1)
      assert true == Map.has_key?(dump_res.hostnames, hn2)
      assert drf1 == Map.get(dump_res.hostnames, hn1).dns_record
      assert drf2 == Map.get(dump_res.hostnames, hn2).dns_record
      assert dump_res = Cache.dump()
      hns1 = Enum.map(dump_res, fn dr -> dr.hostname end)
      assert true == hn1 in hns1
      assert true == hn2 in hns1

      assert :ok == Cache.delete(hn2)
      assert true == Cache.includes?(hn1)
      assert false == Cache.includes?(hn2)
      assert dump_res = Cache.dump_cache()
      assert true == Map.has_key?(dump_res.hostnames, hn1)
      assert false == Map.has_key?(dump_res.hostnames, hn2)
      assert drf1 == Map.get(dump_res.hostnames, hn1).dns_record
      assert nil == Map.get(dump_res.hostnames, hn2)
      assert true == Cache.includes?(hn1)
      assert false == Cache.includes?(hn2)

      assert :ok == Cache.flush()
      assert [] == Cache.dump()
      assert %{} == Cache.dump_cache().hostnames
      assert false == Cache.includes?(hn1)
      assert false == Cache.includes?(hn2)
    end

    test "get/1 returns nil for unknown hostname" do
      refute Cache.includes?("missing.example.com")
      assert Cache.get("missing.example.com") == nil
    end

    test "get/2 with :even_if_expired returns nil for unknown hostname" do
      refute Cache.includes?("missing.example.com")
      assert Cache.get("missing.example.com", :even_if_expired) == nil
    end

    test "includes?/2 with :even_if_expired ignores expiration" do
      hostname = @test_hostname
      dns_record = dns_record_fixture(hostname)

      Cache.add_or_update(dns_record)
      assert Cache.includes?(hostname, :even_if_expired)

      assert :ok == Cache.expire(hostname)
      refute Cache.includes?(hostname)
      assert Cache.includes?(hostname, :even_if_expired)
    end

    test "includes?/2 returns false for an unknown hostname" do
      refute Cache.includes?("still-missing.example.com", :even_if_expired)
    end

    test "expire/1 is a no-op for unknown hostnames" do
      hostname = "missing.example.com"
      refute Cache.includes?(hostname)
      assert :ok == Cache.expire(hostname)
      refute Cache.includes?(hostname)
      refute Cache.includes?(hostname, :even_if_expired)
    end
  end

  defp dns_record_fixture(hostname) do
    %DnsRecord{
      id: "abcd1123",
      zone_id: "",
      hostname: hostname,
      ip: "192.168.2.2",
      type: :MX,
      ttl: 15
    }
  end
end
