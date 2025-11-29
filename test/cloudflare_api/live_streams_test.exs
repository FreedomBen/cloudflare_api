defmodule CloudflareApi.LiveStreamsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LiveStreams

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 includes filter params", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/livestreams?status=LIVE&per_page=50"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ls"}]}}}
    end)

    assert {:ok, [%{"id" => "ls"}]} =
             LiveStreams.list(client, "acc", "app", status: "LIVE", per_page: 50)
  end

  test "create/4 posts payload", %{client: client} do
    params = %{"name" => "marketing_launch"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/livestreams"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = LiveStreams.create(client, "acc", "app", params)
  end

  test "get/5 fetches livestream with pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/livestreams/ls1?per_page=10&page_no=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ls1"}}}}
    end)

    assert {:ok, %{"id" => "ls1"}} =
             LiveStreams.get(client, "acc", "app", "ls1", per_page: 10, page_no: 2)
  end

  test "get_session/4 hits session endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/livestreams/sessions/session123"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "session123"}}}}
    end)

    assert {:ok, %{"id" => "session123"}} =
             LiveStreams.get_session(client, "acc", "app", "session123")
  end

  test "get_active_session/4 fetches active session details", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/livestreams/ls1/active-livestream-session"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "LIVE"}}}}
    end)

    assert {:ok, %{"status" => "LIVE"}} =
             LiveStreams.get_active_session(client, "acc", "app", "ls1")
  end

  test "disable/4 sends PUT with empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"disabled" => true}}}}
    end)

    assert {:ok, %{"disabled" => true}} = LiveStreams.disable(client, "acc", "app", "ls1")
  end

  test "reset_stream_key/4 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"reset" => true}}}}
    end)

    assert {:ok, %{"reset" => true}} = LiveStreams.reset_stream_key(client, "acc", "app", "ls1")
  end

  test "get_meeting_active/4 fetches active livestream for meeting", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting1/active-livestream"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"livestream_id" => "ls1"}}}}
    end)

    assert {:ok, %{"livestream_id" => "ls1"}} =
             LiveStreams.get_meeting_active(client, "acc", "app", "meeting1")
  end

  test "stop_meeting/4 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting1/active-livestream/stop"

      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "unable"}]}}}
    end)

    assert {:error, [%{"message" => "unable"}]} =
             LiveStreams.stop_meeting(client, "acc", "app", "meeting1")
  end

  test "get_meeting_livestream/5 encodes pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting1/livestream?per_page=25&page_no=3"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "session"}]}}}
    end)

    assert {:ok, [_]} =
             LiveStreams.get_meeting_livestream(client, "acc", "app", "meeting1",
               per_page: 25,
               page_no: 3
             )
  end

  test "start_meeting_livestream/5 posts params", %{client: client} do
    params = %{"name" => "launch"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/meeting1/livestreams"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             LiveStreams.start_meeting_livestream(client, "acc", "app", "meeting1", params)
  end

  test "get_session_livestreams/5 fetches using session id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/sessions/session1/livestream-sessions?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             LiveStreams.get_session_livestreams(client, "acc", "app", "session1", per_page: 5)
  end
end
