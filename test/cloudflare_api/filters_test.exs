defmodule CloudflareApi.FiltersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Filters

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 forwards query parameters", %{client: client} do
    opts = [
      description: "browsers",
      expression: "php",
      id: "filter-1",
      page: 2,
      paused: true,
      per_page: 50,
      ref: "FIL-100"
    ]

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/filters" <>
                 "?description=browsers&expression=php&id=filter-1&page=2&paused=true&per_page=50&ref=FIL-100"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "filter-1"}]}}}
    end)

    assert {:ok, [%{"id" => "filter-1"}]} = Filters.list(client, "zone", opts)
  end

  test "create/3 posts a JSON array", %{client: client} do
    payload = [%{"expression" => "ip.src eq 1.1.1.1", "paused" => false}]

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = Filters.create(client, "zone", payload)
  end

  test "update_many/3 sends bulk payload via PUT", %{client: client} do
    payload = [%{"id" => "f1", "description" => "updated"}]

    mock(fn %Tesla.Env{method: :put, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/filters"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => payload}}}
    end)

    assert {:ok, ^payload} = Filters.update_many(client, "zone", payload)
  end

  test "delete_many/3 encodes repeated id params", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/filters?id=f1&id=f2"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "f1"}]}}}
    end)

    assert {:ok, [%{"id" => "f1"}]} = Filters.delete_many(client, "zone", ["f1", "f2"])
  end

  test "delete_many/3 rejects empty id list", %{client: client} do
    assert {:error, :no_filter_ids} = Filters.delete_many(client, "zone", [])
  end

  test "get/3 fetches a single filter", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/filters/filter-1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "filter-1"}}}}
    end)

    assert {:ok, %{"id" => "filter-1"}} = Filters.get(client, "zone", "filter-1")
  end

  test "update/4 sends single filter payload", %{client: client} do
    params = %{"paused" => true}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "filter-1"}}}}
    end)

    assert {:ok, %{"id" => "filter-1"}} =
             Filters.update(client, "zone", "filter-1", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "filter-1"}}}}
    end)

    assert {:ok, %{"id" => "filter-1"}} = Filters.delete(client, "zone", "filter-1")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = Filters.list(client, "zone")
  end
end
