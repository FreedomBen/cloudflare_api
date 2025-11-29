defmodule CloudflareApi.CustomIndicatorFeedsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomIndicatorFeeds

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches feeds", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/indicator-feeds"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "feed"}]}
       }}
    end)

    assert {:ok, [%{"id" => "feed"}]} = CustomIndicatorFeeds.list(client, "acc")
  end

  test "add_permission/3 posts JSON body", %{client: client} do
    params = %{"accounts" => ["acc2"]}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/indicator-feeds/permissions/add"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CustomIndicatorFeeds.add_permission(client, "acc", params)
  end

  test "update_snapshot/4 accepts multipart", %{client: client} do
    multipart =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file_content("data", "feed.stix", name: "source")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/indicator-feeds/feed/snapshot"

      assert match?(%Tesla.Multipart{}, body)
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} =
             CustomIndicatorFeeds.update_snapshot(client, "acc", "feed", multipart)
  end
end
