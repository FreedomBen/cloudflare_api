defmodule CloudflareApi.ZoneRulesetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZoneRulesets

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 supports cursor pagination and create/3 posts JSON", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url |> URI.parse() |> Map.fetch!(:query) |> URI.decode_query() == %{
                 "cursor" => "c123",
                 "per_page" => "20"
               }

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "1"}]}}}

      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/rulesets"
        assert Jason.decode!(body) == %{"kind" => "zone"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "2"}}}}
    end)

    assert {:ok, [%{"id" => "1"}]} =
             ZoneRulesets.list(client, "zone", cursor: "c123", per_page: 20)

    assert {:ok, %{"id" => "2"}} = ZoneRulesets.create(client, "zone", %{"kind" => "zone"})
  end

  test "get/update/delete operate on the same resource", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url == @base <> "/zones/zone/rulesets/abc"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "abc"}}}}

      %Tesla.Env{method: :put, body: body} = env ->
        assert url(env) == "/zones/zone/rulesets/abc"
        assert Jason.decode!(body) == %{"name" => "updated"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "updated"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/rulesets/abc"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "abc"}}}}
    end)

    assert {:ok, %{"id" => "abc"}} = ZoneRulesets.get(client, "zone", "abc")

    assert {:ok, %{"name" => "updated"}} =
             ZoneRulesets.update(client, "zone", "abc", %{"name" => "updated"})

    assert {:ok, %{"id" => "abc"}} = ZoneRulesets.delete(client, "zone", "abc")
  end

  test "rule helpers wrap POST/PATCH/DELETE", %{client: client} do
    mock(fn
      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/rulesets/abc/rules"
        assert Jason.decode!(body) == %{"expression" => "true"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}

      %Tesla.Env{method: :patch, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/rulesets/abc/rules/rule"
        assert Jason.decode!(body) == %{"action" => "skip"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"action" => "skip"}}}}

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert url == @base <> "/zones/zone/rulesets/abc/rules/rule"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} =
             ZoneRulesets.create_rule(client, "zone", "abc", %{"expression" => "true"})

    assert {:ok, %{"action" => "skip"}} =
             ZoneRulesets.update_rule(client, "zone", "abc", "rule", %{"action" => "skip"})

    assert {:ok, %{"id" => "rule"}} = ZoneRulesets.delete_rule(client, "zone", "abc", "rule")
  end

  test "version helpers list/get/delete and filter by tag", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        cond do
          String.ends_with?(url, "/versions/v1/by_tag/block") ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"action" => "block"}]}}}

          String.ends_with?(url, "/versions/v1") ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"version" => "v1"}}}}

          true ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"version" => "v1"}]}}}
        end

      %Tesla.Env{method: :delete, url: url, body: body} = env ->
        assert String.ends_with?(url, "/versions/v1")
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, [%{"version" => "v1"}]} = ZoneRulesets.list_versions(client, "zone", "abc")
    assert {:ok, %{"version" => "v1"}} = ZoneRulesets.get_version(client, "zone", "abc", "v1")
    assert {:ok, %{}} = ZoneRulesets.delete_version(client, "zone", "abc", "v1")

    assert {:ok, [%{"action" => "block"}]} =
             ZoneRulesets.list_version_rules_by_tag(client, "zone", "abc", "v1", "block")
  end

  test "entrypoint helpers fetch, update, and inspect versions", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        cond do
          String.ends_with?(url, "/entrypoint/versions/1") ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"version" => "1"}}}}

          String.ends_with?(url, "/entrypoint/versions") ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"version" => "1"}]}}}

          true ->
            {:ok,
             %Tesla.Env{env | status: 200, body: %{"result" => %{"phase" => "managed_challenge"}}}}
        end

      %Tesla.Env{method: :put, url: url, body: body} = env ->
        assert String.ends_with?(url, "/managed_challenge/entrypoint")
        assert Jason.decode!(body) == %{"name" => "entry"}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "entry"}}}}
    end)

    assert {:ok, %{"phase" => "managed_challenge"}} =
             ZoneRulesets.get_entrypoint(client, "zone", "managed_challenge")

    assert {:ok, %{"name" => "entry"}} =
             ZoneRulesets.update_entrypoint(client, "zone", "managed_challenge", %{
               "name" => "entry"
             })

    assert {:ok, [%{"version" => "1"}]} =
             ZoneRulesets.list_entrypoint_versions(client, "zone", "managed_challenge")

    assert {:ok, %{"version" => "1"}} =
             ZoneRulesets.get_entrypoint_version(client, "zone", "managed_challenge", "1")
  end

  test "errors are surfaced", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = ZoneRulesets.list(client, "zone")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
