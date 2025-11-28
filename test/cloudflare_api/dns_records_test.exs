defmodule CloudflareApi.DnsRecordsTest do
  use ExUnit.Case, async: true

  alias CloudflareApi.DnsRecord
  alias CloudflareApi.DnsRecords

  import Tesla.Mock

  defp client do
    CloudflareApi.new("test-token")
  end

  defp client_fun do
    CloudflareApi.client("test-token")
  end

  describe "list/3" do
    test "returns {:ok, list} on 200 with result" do
      records_json = [
        %{
          "id" => "id-1",
          "zone_id" => "zone",
          "zone_name" => "example.com",
          "name" => "www.example.com",
          "content" => "1.2.3.4",
          "created_on" => "now",
          "type" => "A",
          "ttl" => 120,
          "proxied" => false,
          "proxiable" => true,
          "locked" => false
        }
      ]

      mock(fn
        %Tesla.Env{
          method: :get,
          url: "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => records_json,
              "result_info" => %{
                "page" => 1,
                "per_page" => 20,
                "count" => length(records_json),
                "total_count" => length(records_json)
              }
            }
          }
      end)

      assert {:ok, [record]} = DnsRecords.list(client(), "zone-id")
      assert %DnsRecord{id: "id-1", hostname: "www.example.com", ip: "1.2.3.4"} = record
    end

    test "uses query parameters for spec-aligned filters" do
      records_json = []

      mock(fn
        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=www.example.com&name.contains=example.com&type=AAAA&page=2&per_page=50&order=type&direction=desc"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => records_json,
              "result_info" => %{
                "page" => 2,
                "per_page" => 50,
                "count" => length(records_json),
                "total_count" => 0
              }
            }
          }
      end)

      assert {:ok, []} =
               DnsRecords.list(
                 client(),
                 "zone-id",
                 name: "www.example.com",
                 "name.contains": "example.com",
                 type: "AAAA",
                 page: 2,
                 per_page: 50,
                 order: "type",
                 direction: "desc"
               )
    end

    test "returns {:error, errors} when Cloudflare returns errors" do
      errors = [%{"code" => 1234, "message" => "something went wrong"}]

      mock(fn
        %Tesla.Env{method: :get} ->
          %Tesla.Env{
            status: 400,
            body: %{
              "success" => false,
              "errors" => errors,
              "messages" => [],
              "result" => nil
            }
          }
      end)

      assert {:error, ^errors} = DnsRecords.list(client_fun(), "zone-id")
    end

    test "returns {:error, err} for non-matching responses" do
      mock(fn %Tesla.Env{method: :get} -> {:error, :econnrefused} end)

      assert {:error, {:error, :econnrefused}} = DnsRecords.list(client(), "zone-id")
    end
  end

  describe "list_for_hostname/4 and list_for_host_domain/5" do
    test "list_for_hostname passes hostname and optional type" do
      mock(fn
        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=host.example.com"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }

        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=host.example.com&type=A"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }

        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=host.example.com&type=AAAA"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }
      end)

      assert {:ok, []} = DnsRecords.list_for_hostname(client(), "zone-id", "host.example.com")

      assert {:ok, []} =
               DnsRecords.list_for_hostname(client(), "zone-id", "host.example.com", "A")

      assert {:ok, []} =
               DnsRecords.list_for_hostname(client(), "zone-id", "host.example.com", "AAAA")
    end

    test "list_for_host_domain constructs hostname correctly" do
      mock(fn
        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=www.example.com"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }

        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=already.example.com"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }
      end)

      assert {:ok, []} =
               DnsRecords.list_for_host_domain(client(), "zone-id", "www", "example.com")

      assert {:ok, []} =
               DnsRecords.list_for_host_domain(
                 client(),
                 "zone-id",
                 "already.example.com",
                 "example.com"
               )
    end
  end

  describe "create/3 and create/4" do
    test "create/3 with struct returns {:ok, DnsRecord} on success" do
      dns_struct = %DnsRecord{
        id: nil,
        zone_id: "zone-id",
        zone_name: nil,
        hostname: "www.example.com",
        ip: "1.2.3.4",
        created_on: nil,
        type: :A,
        ttl: 120,
        proxied: false,
        proxiable: true,
        locked: false
      }

      result_json = %{
        "id" => "new-id",
        "zone_id" => "zone-id",
        "zone_name" => "example.com",
        "name" => "www.example.com",
        "content" => "1.2.3.4",
        "created_on" => "now",
        "type" => "A",
        "ttl" => 120,
        "proxied" => false,
        "proxiable" => true,
        "locked" => false
      }

      mock(fn
        %Tesla.Env{
          method: :post,
          url: "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => result_json
            }
          }
      end)

      assert {:ok, %DnsRecord{id: "new-id", hostname: "www.example.com"}} =
               DnsRecords.create(client(), "zone-id", dns_struct)
    end

    test "create/3 with struct returns :already_exists on 81057" do
      mock(fn
        %Tesla.Env{method: :post} ->
          %Tesla.Env{
            status: 400,
            body: %{
              "success" => false,
              "errors" => [%{"code" => 81_057, "message" => "already exists"}],
              "messages" => [],
              "result" => nil
            }
          }
      end)

      dns_struct = %DnsRecord{
        id: nil,
        zone_id: "zone-id",
        zone_name: nil,
        hostname: "www.example.com",
        ip: "1.2.3.4",
        created_on: nil,
        type: :A,
        ttl: 120,
        proxied: false,
        proxiable: true,
        locked: false
      }

      assert {:ok, :already_exists} = DnsRecords.create(client(), "zone-id", dns_struct)
    end

    test "create/4 with fields returns struct on success" do
      result_json = %{
        "id" => "new-id",
        "zone_id" => "zone-id",
        "zone_name" => "example.com",
        "name" => "www.example.com",
        "content" => "1.2.3.4",
        "created_on" => "now",
        "type" => "A",
        "ttl" => 1,
        "proxied" => false,
        "proxiable" => true,
        "locked" => false
      }

      mock(fn
        %Tesla.Env{
          method: :post,
          url: "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => result_json
            }
          }
      end)

      assert {:ok, %DnsRecord{id: "new-id", hostname: "www.example.com"}} =
               DnsRecords.create(client(), "zone-id", "www.example.com", "1.2.3.4")
    end

    test "create/4 returns :already_created on 81057" do
      mock(fn
        %Tesla.Env{method: :post} ->
          %Tesla.Env{
            status: 400,
            body: %{
              "success" => false,
              "errors" => [%{"code" => 81_057, "message" => "already exists"}],
              "messages" => [],
              "result" => nil
            }
          }
      end)

      assert {:ok, :already_created} =
               DnsRecords.create(client(), "zone-id", "www.example.com", "1.2.3.4")
    end

    test "create/3 and create/4 return {:error, errors} for other errors" do
      errors = [%{"code" => 1234, "message" => "other error"}]

      mock(fn %Tesla.Env{method: :post} ->
        %Tesla.Env{
          status: 400,
          body: %{
            "success" => false,
            "errors" => errors,
            "messages" => [],
            "result" => nil
          }
        }
      end)

      dns_struct = %DnsRecord{
        id: nil,
        zone_id: "zone-id",
        zone_name: nil,
        hostname: "www.example.com",
        ip: "1.2.3.4",
        created_on: nil,
        type: :A,
        ttl: 120,
        proxied: false,
        proxiable: true,
        locked: false
      }

      assert {:error, ^errors} = DnsRecords.create(client(), "zone-id", dns_struct)

      assert {:error, ^errors} =
               DnsRecords.create(client(), "zone-id", "www.example.com", "1.2.3.4")
    end
  end

  describe "update/5" do
    test "returns {:ok, DnsRecord} on success" do
      result_json = %{
        "id" => "updated-id",
        "zone_id" => "zone-id",
        "zone_name" => "example.com",
        "name" => "www.example.com",
        "content" => "5.6.7.8",
        "created_on" => "now",
        "type" => "A",
        "ttl" => 1,
        "proxied" => false,
        "proxiable" => true,
        "locked" => false
      }

      mock(fn
        %Tesla.Env{
          method: :put,
          url: "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records/record-id"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => result_json
            }
          }
      end)

      assert {:ok, %DnsRecord{id: "updated-id", ip: "5.6.7.8"}} =
               DnsRecords.update(client(), "zone-id", "record-id", "www.example.com", "5.6.7.8")
    end

    test "returns {:error, errors} when Cloudflare returns errors" do
      errors = [%{"code" => 9999}]

      mock(fn
        %Tesla.Env{method: :put} ->
          %Tesla.Env{
            status: 400,
            body: %{
              "success" => false,
              "errors" => errors,
              "messages" => [],
              "result" => nil
            }
          }
      end)

      assert {:error, ^errors} =
               DnsRecords.update(client(), "zone-id", "record-id", "www.example.com", "5.6.7.8")
    end
  end

  describe "delete/3" do
    test "returns {:ok, id} on success" do
      mock(fn
        %Tesla.Env{
          method: :delete,
          url: "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records/record-id",
          body: "{}"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => %{"id" => "record-id"}
            }
          }
      end)

      assert {:ok, "record-id"} = DnsRecords.delete(client(), "zone-id", "record-id")
    end

    test "returns {:ok, :already_deleted} when record does not exist" do
      mock(fn
        %Tesla.Env{method: :delete} ->
          %Tesla.Env{
            status: 404,
            body: %{
              "success" => false,
              "errors" => [%{"code" => 81_044, "message" => "not found"}],
              "messages" => [],
              "result" => nil
            }
          }
      end)

      assert {:ok, :already_deleted} = DnsRecords.delete(client(), "zone-id", "record-id")
    end

    test "returns {:error, errors} for other errors" do
      errors = [%{"code" => 2345}]

      mock(fn %Tesla.Env{method: :delete} ->
        %Tesla.Env{
          status: 500,
          body: %{
            "success" => false,
            "errors" => errors,
            "messages" => [],
            "result" => nil
          }
        }
      end)

      assert {:error, ^errors} = DnsRecords.delete(client(), "zone-id", "record-id")
    end
  end

  describe "existence helpers" do
    test "hostname_exists?/4 returns true when records are present" do
      result_json = [
        %{"id" => "id-1", "zone_id" => "zone-id", "name" => "host", "content" => "1.2.3.4"}
      ]

      mock(fn
        %Tesla.Env{method: :get} ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => result_json,
              "result_info" => %{
                "page" => 1,
                "per_page" => 20,
                "count" => length(result_json),
                "total_count" => length(result_json)
              }
            }
          }
      end)

      assert DnsRecords.hostname_exists?(client(), "zone-id", "host")
    end

    test "hostname_exists?/4 returns false when no records" do
      mock(fn
        %Tesla.Env{method: :get} ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => [],
              "result_info" => %{"page" => 1, "per_page" => 20, "count" => 0, "total_count" => 0}
            }
          }
      end)

      refute DnsRecords.hostname_exists?(client(), "zone-id", "host")
    end

    test "hostname_exists?/4 raises when underlying call returns error" do
      mock(fn
        %Tesla.Env{method: :get} ->
          %Tesla.Env{
            status: 400,
            body: %{
              "success" => false,
              "errors" => [%{"code" => 1}],
              "messages" => [],
              "result" => nil
            }
          }
      end)

      assert_raise MatchError, fn ->
        DnsRecords.hostname_exists?(client(), "zone-id", "host")
      end
    end

    test "host_domain_exists?/5 behaves the same" do
      result_json = [
        %{
          "id" => "id-1",
          "zone_id" => "zone-id",
          "name" => "www.example.com",
          "content" => "1.2.3.4"
        }
      ]

      mock(fn
        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones/zone-id/dns_records?name=www.example.com"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => result_json,
              "result_info" => %{
                "page" => 1,
                "per_page" => 20,
                "count" => length(result_json),
                "total_count" => length(result_json)
              }
            }
          }
      end)

      assert DnsRecords.host_domain_exists?(client(), "zone-id", "www", "example.com")
    end
  end
end
