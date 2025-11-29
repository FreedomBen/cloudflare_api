defmodule CloudflareApi.StreamVideosTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamVideos

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/stream?per_page=5"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"uid" => "abc"}]}}}
    end)

    assert {:ok, [%{"uid" => "abc"}]} = StreamVideos.list(client, "acc", per_page: 5)
  end

  test "upload_from_url/3 posts JSON", %{client: client} do
    params = %{"url" => "https://example.com/video.mp4"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/stream/copy"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = StreamVideos.upload_from_url(client, "acc", params)
  end

  test "embed_code/3 hits embed endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/video/embed"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "<iframe></iframe>"}}}
    end)

    assert {:ok, "<iframe></iframe>"} = StreamVideos.embed_code(client, "acc", "video")
  end

  test "create_token/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             StreamVideos.create_token(client, "acc", "video", %{"aud" => "watch"})
  end
end
