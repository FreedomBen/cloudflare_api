defmodule CloudflareApi.StreamSubtitlesCaptionsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamSubtitlesCaptions

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 encodes opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/video/captions?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"language" => "en"}]}}}
    end)

    assert {:ok, [%{"language" => "en"}]} =
             StreamSubtitlesCaptions.list(client, "acc", "video", per_page: 5)
  end

  test "upload/5 sends multipart body", %{client: client} do
    upload =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("file", "WEBVTT data", filename: "sub.vtt")

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert match?(%Tesla.Multipart{}, body)
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"language" => "en"}}}}
    end)

    assert {:ok, %{"language" => "en"}} =
             StreamSubtitlesCaptions.upload(client, "acc", "video", "en", upload)
  end

  test "download_vtt/4 passes raw body and generate/delete handle errors", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get, url: url} = env ->
        assert String.ends_with?(url, "/vtt")
        {:ok, %Tesla.Env{env | status: 200, body: "WEBVTT"}}

      %Tesla.Env{method: :post} = env ->
        {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:ok, "WEBVTT"} =
             StreamSubtitlesCaptions.download_vtt(client, "acc", "video", "en")

    assert {:error, [%{"code" => 42}]} =
             StreamSubtitlesCaptions.generate(client, "acc", "video", "en")
  end

  test "delete/4 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"language" => "es"}}}}
    end)

    assert {:ok, %{"language" => "es"}} =
             StreamSubtitlesCaptions.delete(client, "acc", "video", "es")
  end
end
