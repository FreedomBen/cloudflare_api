defmodule CloudflareApi.ZoneAccessGroupsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessGroups

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/access/groups?page=2&per_page=50"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "grp"}]}}}
    end)

    assert {:ok, [%{"id" => "grp"}]} =
             ZoneAccessGroups.list(client, "zone", page: 2, per_page: 50)
  end

  test "create/get/update/delete cover CRUD", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/groups"
        assert Jason.decode!(body) == %{"name" => "admins"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "admins"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/groups/grp"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "grp"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/groups/grp"
        assert Jason.decode!(body) == %{"name" => "updated"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "updated"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/groups/grp"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "admins"}} =
             ZoneAccessGroups.create(client, "zone", %{"name" => "admins"})

    assert {:ok, %{"id" => "grp"}} = ZoneAccessGroups.get(client, "zone", "grp")

    assert {:ok, %{"name" => "updated"}} =
             ZoneAccessGroups.update(client, "zone", "grp", %{"name" => "updated"})

    assert {:ok, %{}} = ZoneAccessGroups.delete(client, "zone", "grp")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [%{"code" => 10}]} = ZoneAccessGroups.list(client, "zone")
  end
end
