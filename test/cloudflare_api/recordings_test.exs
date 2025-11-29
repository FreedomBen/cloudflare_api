defmodule CloudflareApi.RecordingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Recordings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 hits recordings endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/recordings"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "rec"}]}}}
    end)

    assert {:ok, [%{"id" => "rec"}]} = Recordings.list(client, "acc", "app")
  end

  test "start/4 posts params", %{client: client} do
    params = %{"meeting_id" => "m"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rec"}}}}
    end)

    assert {:ok, %{"id" => "rec"}} = Recordings.start(client, "acc", "app", params)
  end

  test "update/5 PUTs payload", %{client: client} do
    params = %{"action" => "pause"}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/recordings/rec"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Recordings.update(client, "acc", "app", "rec", params)
  end

  test "active_recording/4 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} = Recordings.active_recording(client, "acc", "app", "meeting")
  end
end
