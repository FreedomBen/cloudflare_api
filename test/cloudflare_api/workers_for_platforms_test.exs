defmodule CloudflareApi.WorkersForPlatformsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersForPlatforms

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_namespaces/3 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <> "/accounts/acc/workers/dispatch/namespaces?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersForPlatforms.list_namespaces(client, "acc", per_page: 10)
  end

  test "create_namespace/3 sends JSON", %{client: client} do
    params = %{"name" => "ns"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkersForPlatforms.create_namespace(client, "acc", params)
  end

  test "delete_namespace/3 issues delete body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <> "/accounts/acc/workers/dispatch/namespaces/ns"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = WorkersForPlatforms.delete_namespace(client, "acc", "ns")
  end

  test "patch/update namespace", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == %{"description" => "new"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"description" => "new"}}}}
    end)

    assert {:ok, %{"description" => "new"}} =
             WorkersForPlatforms.patch_namespace(client, "acc", "ns", %{"description" => "new"})

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{"name" => "updated"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "updated"}}}}
    end)

    assert {:ok, %{"name" => "updated"}} =
             WorkersForPlatforms.update_namespace(client, "acc", "ns", %{"name" => "updated"})
  end

  test "delete_scripts/4 encodes query", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts?tags=production%3Ayes&limit=100"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.delete_scripts(
               client,
               "acc",
               "ns",
               tags: "production:yes",
               limit: 100
             )
  end

  test "list_scripts/4 supports pagination", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts?cursor=abc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersForPlatforms.list_scripts(client, "acc", "ns", cursor: "abc")
  end

  test "delete/get script", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.delete_script(client, "acc", "ns", "app")

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "app"}}}}
    end)

    assert {:ok, %{"id" => "app"}} =
             WorkersForPlatforms.get_script(client, "acc", "ns", "app")
  end

  test "upload_script_module/5 accepts multipart", %{client: client} do
    body = Tesla.Multipart.new() |> Tesla.Multipart.add_field("metadata", "{}")

    mock(fn %Tesla.Env{method: :put, url: url, body: req_body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app"

      assert req_body == body
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.upload_script_module(client, "acc", "ns", "app", body)
  end

  test "create_assets_upload_session/5 sends JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{"expires_in" => 60}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.create_assets_upload_session(
               client,
               "acc",
               "ns",
               "app",
               %{"expires_in" => 60}
             )
  end

  test "bindings/content endpoints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/bindings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersForPlatforms.get_script_bindings(client, "acc", "ns", "app")

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/content"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.get_script_content(client, "acc", "ns", "app")

    body = Tesla.Multipart.new() |> Tesla.Multipart.add_field("metadata", "{}")

    mock(fn %Tesla.Env{method: :put, url: url, body: req_body, headers: headers} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/content"

      assert req_body == body
      assert {"CF-WORKER-MAIN-MODULE-PART", "main"} in headers
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.put_script_content(
               client,
               "acc",
               "ns",
               "app",
               body,
               [{"CF-WORKER-MAIN-MODULE-PART", "main"}]
             )
  end

  test "secrets helpers", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/secrets"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersForPlatforms.list_script_secrets(client, "acc", "ns", "app")

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{"secrets" => []}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.put_script_secrets(client, "acc", "ns", "app", %{
               "secrets" => []
             })

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/secrets/db"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.delete_script_secret(client, "acc", "ns", "app", "db")

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/secrets/db"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"text" => "secret"}}}}
    end)

    assert {:ok, %{"text" => "secret"}} =
             WorkersForPlatforms.get_script_secret(client, "acc", "ns", "app", "db")
  end

  test "settings and tags", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/settings"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.get_script_settings(client, "acc", "ns", "app")

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/settings"

      assert Jason.decode!(body) == %{"tail_consumers" => []}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.patch_script_settings(
               client,
               "acc",
               "ns",
               "app",
               %{"tail_consumers" => []}
             )

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/tags"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => ["prod"]}}}
    end)

    assert {:ok, ["prod"]} =
             WorkersForPlatforms.get_script_tags(client, "acc", "ns", "app")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/tags"

      assert Jason.decode!(body) == ["prod"]
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => ["prod"]}}}
    end)

    assert {:ok, ["prod"]} =
             WorkersForPlatforms.put_script_tags(client, "acc", "ns", "app", ["prod"])

    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/tags/prod"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.delete_script_tag(client, "acc", "ns", "app", "prod")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/dispatch/namespaces/ns/scripts/app/tags/prod"

      assert Jason.decode!(body) == %{"allowed" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersForPlatforms.put_script_tag(
               client,
               "acc",
               "ns",
               "app",
               "prod",
               %{"allowed" => true}
             )
  end

  test "error propagation", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 403, body: %{"errors" => [%{"code" => 88}]}}}
    end)

    assert {:error, [_]} = WorkersForPlatforms.list_namespaces(client, "acc")
  end
end
