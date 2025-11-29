defmodule CloudflareApi.ZarazTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Zaraz

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_config/2 fetches config", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/zones/zone/settings/zaraz/config"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} = Zaraz.get_config(client, "zone")
  end

  test "put_config/3 sends body", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/config"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Zaraz.put_config(client, "zone", params)
  end

  test "get_default/2 fetches defaults", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/default"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Zaraz.get_default(client, "zone")
  end

  test "export/2 returns export data", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/export"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Zaraz.export(client, "zone")
  end

  test "history endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/zones/zone/settings/zaraz/history?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Zaraz.get_history(client, "zone", page: 2)

    params = %{"limit" => 10}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/history"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Zaraz.put_history(client, "zone", params)

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/zones/zone/settings/zaraz/history/configs?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Zaraz.get_history_configs(client, "zone", page: 1)
  end

  test "publish/3 posts", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/publish"
      assert Jason.decode!(body) == %{"comment" => "deploy"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             Zaraz.publish(client, "zone", %{"comment" => "deploy"})
  end

  test "workflow endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/workflow"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Zaraz.get_workflow(client, "zone")

    params = %{"steps" => []}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert url(env) == "/zones/zone/settings/zaraz/workflow"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Zaraz.put_workflow(client, "zone", params)
  end

  test "handles Zaraz errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [_]} = Zaraz.get_config(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
