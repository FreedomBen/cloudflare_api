defmodule CloudflareApi.PagesProjectTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PagesProject

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes pagination params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/pages/projects?page=2&per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "site"}]}}}
    end)

    assert {:ok, [%{"name" => "site"}]} = PagesProject.list(client, "acc", page: 2, per_page: 5)
  end

  test "create/3 sends project definition", %{client: client} do
    params = %{"name" => "my-app", "production_branch" => "main"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = PagesProject.create(client, "acc", params)
  end

  test "update/4 patches project", %{client: client} do
    params = %{"production_branch" => "stable"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{env | status: 200, body: %{"result" => %{"production_branch" => "stable"}}}}
    end)

    assert {:ok, %{"production_branch" => "stable"}} =
             PagesProject.update(client, "acc", "my-app", params)
  end

  test "delete/3 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:error, [%{"code" => 42}]} = PagesProject.delete(client, "acc", "my-app")
  end
end
