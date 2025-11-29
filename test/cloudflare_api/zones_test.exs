defmodule CloudflareApi.ZonesTest do
  use ExUnit.Case, async: true

  alias CloudflareApi.Zones

  import Tesla.Mock

  defp client do
    CloudflareApi.new("test-token")
  end

  describe "list/2" do
    test "returns {:ok, zones} on 200 success" do
      zones = [%{"id" => "zone-1"}, %{"id" => "zone-2"}]

      mock(fn
        %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/zones"} ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => zones,
              "result_info" => %{
                "page" => 1,
                "per_page" => 20,
                "count" => length(zones),
                "total_count" => length(zones)
              }
            }
          }
      end)

      assert {:ok, ^zones} = Zones.list(client(), nil)
    end

    test "encodes spec-aligned query params" do
      zones = []

      mock(fn
        %Tesla.Env{
          method: :get,
          url:
            "https://api.cloudflare.com/client/v4/zones?name=example.com&status=active&account.id=acc-1&account.name=DevAccount&page=2&per_page=50&order=name&direction=desc&match=all"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => zones,
              "result_info" => %{
                "page" => 2,
                "per_page" => 50,
                "count" => length(zones),
                "total_count" => 0
              }
            }
          }
      end)

      assert {:ok, ^zones} =
               Zones.list(
                 client(),
                 name: "example.com",
                 status: "active",
                 "account.id": "acc-1",
                 "account.name": "DevAccount",
                 page: 2,
                 per_page: 50,
                 order: "name",
                 direction: "desc",
                 match: "all"
               )
    end

    test "returns {:ok, zones} with options" do
      zones = [%{"id" => "zone-1"}]

      mock(fn
        %Tesla.Env{
          method: :get,
          url: "https://api.cloudflare.com/client/v4/zones?name=example.com"
        } ->
          %Tesla.Env{
            status: 200,
            body: %{
              "success" => true,
              "errors" => [],
              "messages" => [],
              "result" => zones,
              "result_info" => %{
                "page" => 1,
                "per_page" => 20,
                "count" => length(zones),
                "total_count" => length(zones)
              }
            }
          }
      end)

      assert {:ok, ^zones} = Zones.list(client(), name: "example.com")
    end

    test "returns {:error, errors} when Cloudflare returns errors" do
      errors = [%{"code" => 1000}]

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

      assert {:error, ^errors} = Zones.list(client(), nil)
    end

    test "returns {:error, err} for other failures" do
      mock(fn %Tesla.Env{method: :get} -> {:error, :timeout} end)

      assert {:error, {:error, :timeout}} = Zones.list(client(), nil)
    end
  end

  describe "mutations" do
    test "create/2 posts JSON" do
      params = %{"name" => "example.com"}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == "https://api.cloudflare.com/client/v4/zones"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} = Zones.create(client(), params)
    end

    test "delete/2 sends empty body" do
      mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == "https://api.cloudflare.com/client/v4/zones/zone%2F1"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} = Zones.delete(client(), "zone/1")
    end

    test "get/2 fetches zone" do
      mock(fn %Tesla.Env{method: :get, url: url} = env ->
        assert url == "https://api.cloudflare.com/client/v4/zones/zone"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "zone"}}}}
      end)

      assert {:ok, %{"id" => "zone"}} = Zones.get(client(), "zone")
    end

    test "patch/3 sends JSON" do
      params = %{"paused" => true}

      mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
        assert url == "https://api.cloudflare.com/client/v4/zones/zone"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
      end)

      assert {:ok, ^params} = Zones.patch(client(), "zone", params)
    end

    test "activation_check/2 PUTs empty body" do
      mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url ==
                 "https://api.cloudflare.com/client/v4/zones/zone/activation_check"

        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} = Zones.activation_check(client(), "zone")
    end

    test "purge_cache/3 posts payload" do
      params = %{"purge_everything" => true}

      mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == "https://api.cloudflare.com/client/v4/zones/zone/purge_cache"
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
      end)

      assert {:ok, %{}} = Zones.purge_cache(client(), "zone", params)
    end
  end
end
