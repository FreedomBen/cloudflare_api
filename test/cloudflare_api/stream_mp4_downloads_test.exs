defmodule CloudflareApi.StreamMp4DownloadsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamMp4Downloads

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create_for_type/5 posts payload", %{client: client} do
    params = %{"quality" => "source"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/video/downloads/mp4"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             StreamMp4Downloads.create_for_type(client, "acc", "video", "mp4", params)
  end

  test "delete_for_type/4 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 409, body: %{"errors" => [%{"code" => 3001}]}}}
    end)

    assert {:error, [%{"code" => 3001}]} =
             StreamMp4Downloads.delete_for_type(client, "acc", "video", "mp4")
  end
end
