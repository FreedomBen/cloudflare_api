defmodule CloudflareApi.WorkerScriptTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkerScript

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :list_scripts,
      args: ["acc", [tags: "prod"]],
      method: :get,
      path: "/accounts/acc/workers/scripts?tags=prod"
    },
    %{
      fun: :search_scripts,
      args: ["acc", [page: 2]],
      method: :get,
      path: "/accounts/acc/workers/scripts-search?page=2"
    },
    %{
      fun: :delete_script,
      args: ["acc", "my/script", [force: true]],
      method: :delete,
      path: "/accounts/acc/workers/scripts/my%2Fscript?force=true",
      json: %{}
    },
    %{
      fun: :get_script,
      args: ["acc", "my/script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/my%2Fscript"
    },
    %{
      fun: :create_assets_upload_session,
      args: ["acc", "script", %{"expires_in" => 60}],
      method: :post,
      path: "/accounts/acc/workers/scripts/script/assets-upload-session",
      json: %{"expires_in" => 60}
    },
    %{
      fun: :get_content,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/content/v2"
    },
    %{
      fun: :get_script_settings,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/script-settings"
    },
    %{
      fun: :patch_script_settings,
      args: ["acc", "script", %{"logpush" => true}],
      method: :patch,
      path: "/accounts/acc/workers/scripts/script/script-settings",
      json: %{"logpush" => true}
    },
    %{
      fun: :get_settings,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/settings"
    },
    %{
      fun: :list_secrets,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/secrets"
    },
    %{
      fun: :put_secret,
      args: ["acc", "script", %{"name" => "API_KEY"}],
      method: :put,
      path: "/accounts/acc/workers/scripts/script/secrets",
      json: %{"name" => "API_KEY"}
    },
    %{
      fun: :delete_secret,
      args: ["acc", "script", "secret/name", [url_encoded: true]],
      method: :delete,
      path: "/accounts/acc/workers/scripts/script/secrets/secret%2Fname?url_encoded=true"
    },
    %{
      fun: :get_secret,
      args: ["acc", "script", "secret/name", [url_encoded: true]],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/secrets/secret%2Fname?url_encoded=true"
    },
    %{
      fun: :delete_subdomain,
      args: ["acc", "script"],
      method: :delete,
      path: "/accounts/acc/workers/scripts/script/subdomain",
      json: %{}
    },
    %{
      fun: :get_subdomain,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/subdomain"
    },
    %{
      fun: :create_subdomain,
      args: ["acc", "script", %{"subdomain" => "example"}],
      method: :post,
      path: "/accounts/acc/workers/scripts/script/subdomain",
      json: %{"subdomain" => "example"}
    },
    %{
      fun: :get_usage_model,
      args: ["acc", "script"],
      method: :get,
      path: "/accounts/acc/workers/scripts/script/usage-model"
    },
    %{
      fun: :update_usage_model,
      args: ["acc", "script", %{"usage_model" => "standard"}],
      method: :put,
      path: "/accounts/acc/workers/scripts/script/usage-model",
      json: %{"usage_model" => "standard"}
    }
  ]

  for %{fun: fun, args: args, method: method, path: path} = entry <- @cases do
    json = Map.get(entry, :json, :no_json)

    test "#{fun} targets #{path}", %{client: client} do
      mock(fn %Tesla.Env{method: unquote(method), url: url} = env ->
        assert url == @base <> unquote(path)

        case unquote(Macro.escape(json)) do
          :no_json ->
            :ok

          expected ->
            assert Jason.decode!(env.body) == expected
        end

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
      end)

      assert {:ok, %{"ok" => true}} =
               apply(WorkerScript, unquote(fun), [client | unquote(Macro.escape(args))])
    end
  end

  test "upload_assets/4 sends multipart body with query", %{client: client} do
    body = multipart_fixture()

    mock(fn %Tesla.Env{method: :post, url: url, body: req_body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/workers/assets/upload?base64=true"

      assert req_body == body
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "session"}}}}
    end)

    assert {:ok, %{"id" => "session"}} =
             WorkerScript.upload_assets(client, "acc", body, base64: true)
  end

  test "upload_module/4 posts multipart script", %{client: client} do
    body = multipart_fixture()

    mock(fn %Tesla.Env{method: :put, url: url, body: req_body} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script"
      assert req_body == body
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "script"}}}}
    end)

    assert {:ok, %{"id" => "script"}} =
             WorkerScript.upload_module(client, "acc", "script", body)
  end

  test "put_content/5 carries headers", %{client: client} do
    body = multipart_fixture()
    headers = [{"CF-WORKER-MAIN-MODULE-PART", "main"}]

    mock(fn %Tesla.Env{method: :put, url: url, body: req_body, headers: req_headers} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/content"
      assert req_body == body
      assert {"CF-WORKER-MAIN-MODULE-PART", "main"} in req_headers
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"updated" => true}}}}
    end)

    assert {:ok, %{"updated" => true}} =
             WorkerScript.put_content(client, "acc", "script", body, headers)
  end

  test "patch_settings/4 accepts multipart body", %{client: client} do
    body =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("settings", ~s({"placement":{"mode":"smart"}}))

    mock(fn %Tesla.Env{method: :patch, url: url, body: req_body} = env ->
      assert url == @base <> "/accounts/acc/workers/scripts/script/settings"
      assert req_body == body
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             WorkerScript.patch_settings(client, "acc", "script", body)
  end

  test "propagates script errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 55}]}}}
    end)

    assert {:error, [%{"code" => 55}]} =
             WorkerScript.list_scripts(client, "acc")
  end

  defp multipart_fixture do
    Tesla.Multipart.new()
    |> Tesla.Multipart.add_field("metadata", ~s({"main_module":"worker.js"}))
  end
end
