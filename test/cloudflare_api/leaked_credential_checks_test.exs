defmodule CloudflareApi.LeakedCredentialChecksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LeakedCredentialChecks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_status/2 fetches current status", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "on"}}}}
    end)

    assert {:ok, %{"status" => "on"}} = LeakedCredentialChecks.get_status(client, "zone")
  end

  test "set_status/3 posts desired state", %{client: client} do
    params = %{"status" => "off"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LeakedCredentialChecks.set_status(client, "zone", params)
  end

  test "list_detections/2 returns custom detections", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks/detections"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "det"}]}}}
    end)

    assert {:ok, [%{"id" => "det"}]} = LeakedCredentialChecks.list_detections(client, "zone")
  end

  test "create_detection/3 posts detection params", %{client: client} do
    params = %{"name" => "admin login", "expression" => "user.email contains \"admin\""}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks/detections"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LeakedCredentialChecks.create_detection(client, "zone", params)
  end

  test "get_detection/3 fetches detection details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks/detections/det"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "det"}}}}
    end)

    assert {:ok, %{"id" => "det"}} = LeakedCredentialChecks.get_detection(client, "zone", "det")
  end

  test "update_detection/4 puts params", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn %Tesla.Env{method: :put, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks/detections/det"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             LeakedCredentialChecks.update_detection(client, "zone", "det", params)
  end

  test "delete_detection/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/leaked-credential-checks/detections/det"

      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "det"}}}}
    end)

    assert {:ok, %{"id" => "det"}} =
             LeakedCredentialChecks.delete_detection(client, "zone", "det")
  end

  test "update_detection/4 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 7000}]}}}
    end)

    assert {:error, [%{"code" => 7000}]} =
             LeakedCredentialChecks.update_detection(client, "zone", "det", %{"name" => "bad"})
  end
end
