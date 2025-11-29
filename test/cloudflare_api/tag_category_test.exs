defmodule CloudflareApi.TagCategoryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TagCategory

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/tags/categories?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "cat"}]}}}
    end)

    assert {:ok, [%{"name" => "cat"}]} = TagCategory.list(client, "acc", page: 2)
  end

  test "create/3 posts payload", %{client: client} do
    params = %{"name" => "new"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = TagCategory.create(client, "acc", params)
  end

  test "delete/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} = TagCategory.delete(client, "acc", "uuid")
  end
end
