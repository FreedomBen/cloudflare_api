defmodule CloudflareApi.TriggersTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Triggers

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "nightly"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Triggers.create(client, "acc", params)
  end

  test "create_manual_build/4 posts empty map by default", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert String.ends_with?(url, "/builds")
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "build"}}}}
    end)

    assert {:ok, %{"id" => "build"}} =
             Triggers.create_manual_build(client, "acc", "trigger")
  end

  test "purge_build_cache/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 12}]}}}
    end)

    assert {:error, [%{"code" => 12}]} =
             Triggers.purge_build_cache(client, "acc", "trigger")
  end
end
