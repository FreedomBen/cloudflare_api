defmodule CloudflareApi.BuildsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Builds

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_by_version_ids/3 accepts list inputs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/builds?version_ids=one%2Ctwo"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "one"}]}
       }}
    end)

    assert {:ok, [%{"id" => "one"}]} = Builds.list_by_version_ids(client, "acc", ["one", "two"])
  end

  test "latest_by_scripts/3 encodes script IDs", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/builds/latest?external_script_ids=worker"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"external_script_id" => "worker"}]}
       }}
    end)

    assert {:ok, [%{"external_script_id" => "worker"}]} =
             Builds.latest_by_scripts(client, "acc", "worker")
  end

  test "get/3 fetches build details", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/builds/build"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "build"}}
       }}
    end)

    assert {:ok, %{"id" => "build"}} = Builds.get(client, "acc", "build")
  end

  test "cancel/3 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/builds/build/cancel"

      {:ok,
       %Tesla.Env{
         env
         | status: 409,
           body: %{"errors" => [%{"code" => 7000, "message" => "already completed"}]}
       }}
    end)

    assert {:error, [%{"code" => 7000, "message" => "already completed"}]} =
             Builds.cancel(client, "acc", "build")
  end

  test "logs/4 encodes optional cursor", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/builds/build/logs?cursor=abc"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"entries" => []}}
       }}
    end)

    assert {:ok, %{"entries" => []}} =
             Builds.logs(client, "acc", "build", cursor: "abc")
  end
end
