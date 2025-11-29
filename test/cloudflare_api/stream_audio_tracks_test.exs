defmodule CloudflareApi.StreamAudioTracksTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamAudioTracks

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/video/audio?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"language" => "en"}]}}}
    end)

    assert {:ok, [%{"language" => "en"}]} =
             StreamAudioTracks.list(client, "acc", "video", per_page: 5)
  end

  test "add/4 posts JSON", %{client: client} do
    params = %{"audio_identifier" => "src"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = StreamAudioTracks.add(client, "acc", "video", params)
  end

  test "update/5 patches payload and delete/5 handles errors", %{client: client} do
    params = %{"default" => true}

    mock(fn
      %Tesla.Env{method: :patch, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1006}]}}}
    end)

    assert {:ok, ^params} =
             StreamAudioTracks.update(client, "acc", "video", "audio-id", params)

    assert {:error, [%{"code" => 1006}]} =
             StreamAudioTracks.delete(client, "acc", "video", "audio-id")
  end
end
