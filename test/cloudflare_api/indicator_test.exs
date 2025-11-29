defmodule CloudflareApi.IndicatorTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Indicator

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits dataset indicators endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/indicators?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"uuid" => "id"}]}}}
    end)

    assert {:ok, [%{"uuid" => "id"}]} = Indicator.list(client, "acc", "ds", page: 2)
  end

  test "list_all/3 hits multi-dataset endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/indicators"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"indicators" => []}}}}
    end)

    assert {:ok, %{"indicators" => []}} = Indicator.list_all(client, "acc")
  end

  test "create/4 posts indicator payload", %{client: client} do
    params = %{"indicatorType" => "domain", "value" => "example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/indicators/create"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Indicator.create(client, "acc", "ds", params)
  end

  test "create_bulk/4 posts to bulk endpoint", %{client: client} do
    params = %{"indicators" => []}

    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/indicators/bulk"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Indicator.create_bulk(client, "acc", "ds", params)
  end

  test "update/5 patches indicator", %{client: client} do
    params = %{"value" => "new"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/indicators/ind"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Indicator.update(client, "acc", "ds", "ind", params)
  end

  test "delete/5 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"uuid" => "ind"}}}}
    end)

    assert {:ok, %{"uuid" => "ind"}} = Indicator.delete(client, "acc", "ds", "ind")
  end

  test "list_tags/4 hits tags path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/indicators/tags"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Indicator.list_tags(client, "acc", "ds")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = Indicator.list(client, "acc", "ds")
  end
end
