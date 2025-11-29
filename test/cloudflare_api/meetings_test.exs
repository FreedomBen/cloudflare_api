defmodule CloudflareApi.MeetingsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Meetings

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 applies query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      %URI{path: path, query: query} = URI.parse(url)

      assert path ==
               "/client/v4/accounts/acc/realtime/kit/app/meetings"

      assert URI.decode_query(query) == %{"page" => "2"}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = Meetings.list(client, "acc", "app", page: 2)
  end

  test "create/4 posts meeting definition", %{client: client} do
    params = %{"name" => "daily-sync"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Meetings.create(client, "acc", "app", params)
  end

  test "list_participants/5 hits participant endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/mtg/participants?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             Meetings.list_participants(client, "acc", "app", "mtg", per_page: 10)
  end

  test "add_participant/5 posts payload", %{client: client} do
    params = %{"name" => "Alice"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             Meetings.add_participant(client, "acc", "app", "mtg", params)
  end

  test "delete_participant/5 returns :no_content", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok, %Tesla.Env{env | status: 204}}
    end)

    assert {:ok, :no_content} =
             Meetings.delete_participant(client, "acc", "app", "mtg", "part")
  end

  test "regenerate_participant_token/5 posts empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/realtime/kit/app/meetings/mtg/participants/part/token"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"token" => "new"}}}}
    end)

    assert {:ok, %{"token" => "new"}} =
             Meetings.regenerate_participant_token(client, "acc", "app", "mtg", "part")
  end

  test "replace meeting propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 2020}]}}}
    end)

    assert {:error, [%{"code" => 2020}]} =
             Meetings.replace(client, "acc", "app", "mtg", %{"name" => "other"})
  end
end
