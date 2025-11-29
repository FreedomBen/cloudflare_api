defmodule CloudflareApi.ZoneAccessApplicationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneAccessApplications

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 and create/3 cover the collection endpoint", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/apps"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "app"}]}}}

      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps"
        assert Jason.decode!(body) == %{"name" => "Example"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "app"}}}}
    end)

    assert {:ok, [%{"id" => "app"}]} = ZoneAccessApplications.list(client, "zone")

    assert {:ok, %{"id" => "app"}} =
             ZoneAccessApplications.create(client, "zone", %{"name" => "Example"})
  end

  test "get/update/delete operate against a single application", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/access/apps/app"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Example"}}}}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app"
        assert Jason.decode!(body) == %{"name" => "Updated"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Updated"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"name" => "Example"}} = ZoneAccessApplications.get(client, "zone", "app")

    assert {:ok, %{"name" => "Updated"}} =
             ZoneAccessApplications.update(client, "zone", "app", %{"name" => "Updated"})

    assert {:ok, %{}} = ZoneAccessApplications.delete(client, "zone", "app")
  end

  test "settings and policy-test helpers hit nested endpoints", %{client: client} do
    mock(fn
      %Tesla.Env{method: :patch, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/settings"
        assert Jason.decode!(body) == %{"http_only_cookie_attribute" => "on"}

        {:ok,
         %Tesla.Env{
           env
           | status: 200,
             body: %{"result" => %{"http_only_cookie_attribute" => "on"}}
         }}

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/settings"
        assert Jason.decode!(body) == %{"session_duration" => "24h"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"session_duration" => "24h"}}}}

      %Tesla.Env{method: :get, url: url} = env ->
        assert String.contains?(url, "user_policy_checks")
        assert URI.parse(url).query |> URI.decode_query() == %{"email" => "user@example.com"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"allow" => true}}}}

      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/access/apps/app/revoke_tokens"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{"http_only_cookie_attribute" => "on"}} =
             ZoneAccessApplications.patch_settings(
               client,
               "zone",
               "app",
               %{"http_only_cookie_attribute" => "on"}
             )

    assert {:ok, %{"session_duration" => "24h"}} =
             ZoneAccessApplications.put_settings(client, "zone", "app", %{
               "session_duration" => "24h"
             })

    assert {:ok, %{"allow" => true}} =
             ZoneAccessApplications.test_policies(client, "zone", "app",
               email: "user@example.com"
             )

    assert {:ok, %{}} = ZoneAccessApplications.revoke_tokens(client, "zone", "app")
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             ZoneAccessApplications.create(client, "zone", %{"name" => ""})
  end
end
