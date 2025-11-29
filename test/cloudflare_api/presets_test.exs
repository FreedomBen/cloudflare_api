defmodule CloudflareApi.PresetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Presets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/presets?page=1"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "preset"}]}}}
    end)

    assert {:ok, [%{"id" => "preset"}]} = Presets.list(client, "acc", "app", page: 1)
  end

  test "update/5 uses PATCH", %{client: client} do
    params = %{"name" => "webinar"}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/presets/pre"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Presets.update(client, "acc", "app", "pre", params)
  end

  test "delete/4 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Presets.delete(client, "acc", "app", "pre")
  end

  test "create/4 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 123}]}}}
    end)

    assert {:error, [%{"code" => 123}]} = Presets.create(client, "acc", "app", %{"name" => "x"})
  end
end
