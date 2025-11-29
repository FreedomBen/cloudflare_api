defmodule CloudflareApi.TagTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Tag

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits base endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/tags?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "tag"}]}}}
    end)

    assert {:ok, [%{"name" => "tag"}]} = Tag.list(client, "acc", per_page: 10)
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"name" => "new"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/tags/create"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Tag.create(client, "acc", params)
  end

  test "update/4 patches body and delete/3 surfaces errors", %{client: client} do
    params = %{"description" => "updated"}

    mock(fn
      %Tesla.Env{method: :patch, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:ok, ^params} = Tag.update(client, "acc", "uuid", params)
    assert {:error, [%{"code" => 404}]} = Tag.delete(client, "acc", "uuid")
  end

  test "list_indicators/5 builds dataset path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds/tags/tag%2Fid/indicators?per_page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ind"}]}}}
    end)

    assert {:ok, [%{"id" => "ind"}]} =
             Tag.list_indicators(client, "acc", "ds", "tag/id", per_page: 1)
  end
end
