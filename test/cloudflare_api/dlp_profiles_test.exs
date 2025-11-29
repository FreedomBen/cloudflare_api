defmodule CloudflareApi.DlpProfilesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpProfiles

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 passes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles?all=true"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "profile"}]}}}
    end)

    assert {:ok, [_]} = DlpProfiles.list(client, "acc", all: true)
  end

  test "create_custom/3 posts JSON", %{client: client} do
    params = %{"name" => "Custom"}

    mock(fn %Tesla.Env{url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/custom"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "prof"}}}}
    end)

    assert {:ok, %{"id" => "prof"}} = DlpProfiles.create_custom(client, "acc", params)
  end

  test "get_custom/3 retrieves profile", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/custom/id"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "id"}}}}
    end)

    assert {:ok, %{"id" => "id"}} = DlpProfiles.get_custom(client, "acc", "id")
  end

  test "update_custom/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             DlpProfiles.update_custom(client, "acc", "id", %{"name" => "x"})
  end

  test "delete_custom/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             DlpProfiles.delete_custom(client, "acc", "id")
  end

  test "predefined config helpers hit config subresource", %{client: client} do
    params = %{"enabled" => true}

    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert url ==
                 "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/predefined/pid/config"

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cfg"}}}}

      %Tesla.Env{method: :post, url: url, body: body} = env ->
        assert url ==
                 "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/predefined/pid/config"

        assert Jason.decode!(body) == params

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"created" => true}}}}
    end)

    assert {:ok, %{"id" => "cfg"}} =
             DlpProfiles.predefined_config(client, "acc", "pid")

    assert {:ok, %{"created" => true}} =
             DlpProfiles.create_predefined_config(client, "acc", "pid", params)
  end

  test "update_predefined_config/4 uses PUT", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/predefined/pid/config"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             DlpProfiles.update_predefined_config(client, "acc", "pid", params)
  end

  test "get_profile/3 hits generic profile path", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/profiles/prof"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "prof"}}}}
    end)

    assert {:ok, %{"id" => "prof"}} = DlpProfiles.get_profile(client, "acc", "prof")
  end
end
