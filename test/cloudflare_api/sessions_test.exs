defmodule CloudflareApi.SessionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Sessions

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/sessions?per_page=25&search=test"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"data" => []}}}}
    end)

    assert {:ok, %{"data" => []}} =
             Sessions.list(client, "acc", "app", per_page: 25, search: "test")
  end

  test "participant/5 encodes participant id", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/sessions/sess/participants/part%2Fid?filters=device_info"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "part/id"}}}}
    end)

    assert {:ok, %{"id" => "part/id"}} =
             Sessions.participant(client, "acc", "app", "sess", "part/id", filters: "device_info")
  end

  test "participant_from_peer/4 hits peer-report endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/sessions/peer-report/peer123?filters=events"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"peer_id" => "peer123"}}}}
    end)

    assert {:ok, %{"peer_id" => "peer123"}} =
             Sessions.participant_from_peer(client, "acc", "app", "peer123", filters: "events")
  end

  test "generate_summary/4 posts empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"success" => true}}}}
    end)

    assert {:ok, %{"success" => true}} =
             Sessions.generate_summary(client, "acc", "app", "sess")
  end

  test "chat/4 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} = Sessions.chat(client, "acc", "app", "sess")
  end
end
