defmodule CloudflareApi.ZoneLockdownTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneLockdown

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards filters as query params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url |> URI.parse() |> Map.fetch!(:query) |> URI.decode_query() == %{
               "page" => "2",
               "per_page" => "10",
               "description" => "api"
             }

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             ZoneLockdown.list(client, "zone", page: 2, per_page: 10, description: "api")
  end

  test "CRUD helpers hit the expected endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/firewall/lockdowns"
        assert Jason.decode!(body) == %{"configurations" => []}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lk"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/firewall/lockdowns/lk"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lk"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/firewall/lockdowns/lk"
        assert Jason.decode!(body) == %{"paused" => true}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"paused" => true}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/firewall/lockdowns/lk"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "lk"}}}}
    end)

    assert {:ok, %{"id" => "lk"}} =
             ZoneLockdown.create(client, "zone", %{"configurations" => []})

    assert {:ok, %{"id" => "lk"}} = ZoneLockdown.get(client, "zone", "lk")

    assert {:ok, %{"paused" => true}} =
             ZoneLockdown.update(client, "zone", "lk", %{"paused" => true})

    assert {:ok, %{"id" => "lk"}} = ZoneLockdown.delete(client, "zone", "lk")
  end

  test "API errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1001}]}}}
    end)

    assert {:error, [%{"code" => 1001}]} = ZoneLockdown.list(client, "zone")
  end
end
