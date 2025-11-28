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
          %Tesla.Env{status: 200, body: %{"result" => zones}}
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
          %Tesla.Env{status: 200, body: %{"result" => zones}}
      end)

      assert {:ok, ^zones} =
               Zones.list(
                 client(),
                 [
                   name: "example.com",
                   status: "active",
                   "account.id": "acc-1",
                   "account.name": "DevAccount",
                   page: 2,
                   per_page: 50,
                   order: "name",
                   direction: "desc",
                   match: "all"
                 ]
               )
    end

    test "returns {:ok, zones} with options" do
      zones = [%{"id" => "zone-1"}]

      mock(fn
        %Tesla.Env{
          method: :get,
          url: "https://api.cloudflare.com/client/v4/zones?name=example.com"
        } ->
          %Tesla.Env{status: 200, body: %{"result" => zones}}
      end)

      assert {:ok, ^zones} = Zones.list(client(), name: "example.com")
    end

    test "returns {:error, errors} when Cloudflare returns errors" do
      errors = [%{"code" => 1000}]

      mock(fn
        %Tesla.Env{method: :get} ->
          %Tesla.Env{status: 400, body: %{"errors" => errors}}
      end)

      assert {:error, ^errors} = Zones.list(client(), nil)
    end

    test "returns {:error, err} for other failures" do
      mock(fn %Tesla.Env{method: :get} -> {:error, :timeout} end)

      assert {:error, {:error, :timeout}} = Zones.list(client(), nil)
    end
  end
end
