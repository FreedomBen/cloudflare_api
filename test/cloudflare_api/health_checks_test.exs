defmodule CloudflareApi.HealthChecksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.HealthChecks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 passes pagination params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/healthchecks?page=2&per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "hc"}]}}}
    end)

    assert {:ok, [%{"id" => "hc"}]} = HealthChecks.list(client, "zone", page: 2, per_page: 50)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"method" => "GET"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = HealthChecks.create(client, "zone", params)
  end

  test "update/4 hits the health check resource", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/healthchecks/hc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = HealthChecks.update(client, "zone", "hc", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "hc"}}}}
    end)

    assert {:ok, %{"id" => "hc"}} = HealthChecks.delete(client, "zone", "hc")
  end

  test "preview endpoints use preview paths", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      case {env.method, env.url} do
        {:post, "https://api.cloudflare.com/client/v4/zones/zone/healthchecks/preview"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "preview"}}}}

        {:delete, "https://api.cloudflare.com/client/v4/zones/zone/healthchecks/preview/preview"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "preview"}}}}

        {:get, "https://api.cloudflare.com/client/v4/zones/zone/healthchecks/preview/preview"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "preview"}}}}
      end
    end)

    assert {:ok, %{"id" => "preview"}} = HealthChecks.create_preview(client, "zone", %{})
    assert {:ok, %{"id" => "preview"}} = HealthChecks.get_preview(client, "zone", "preview")
    assert {:ok, %{"id" => "preview"}} = HealthChecks.delete_preview(client, "zone", "preview")
  end

  test "smart_* functions hit smart shield paths", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      case {env.method, env.url} do
        {:get, "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/healthchecks"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        {:post, "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/healthchecks"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "s1"}}}}

        {:patch, "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/healthchecks/s1"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "s1"}}}}

        {:delete, "https://api.cloudflare.com/client/v4/zones/zone/smart_shield/healthchecks/s1"} ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "s1"}}}}
      end
    end)

    assert {:ok, []} = HealthChecks.smart_list(client, "zone")
    assert {:ok, %{"id" => "s1"}} = HealthChecks.smart_create(client, "zone", %{})
    assert {:ok, %{"id" => "s1"}} = HealthChecks.smart_patch(client, "zone", "s1", %{})
    assert {:ok, %{"id" => "s1"}} = HealthChecks.smart_delete(client, "zone", "s1")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = HealthChecks.list(client, "zone")
  end
end
