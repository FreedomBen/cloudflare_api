defmodule CloudflareApi.StreamWatermarkProfileTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamWatermarkProfile

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/watermarks?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"uid" => "wm"}]}}}
    end)

    assert {:ok, [%{"uid" => "wm"}]} =
             StreamWatermarkProfile.list(client, "acc", page: 1)
  end

  test "create/3 accepts multipart body", %{client: client} do
    upload =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("file", "binary watermark", filename: "wm.png")

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert match?(%Tesla.Multipart{}, body)
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"uid" => "new"}}}}
    end)

    assert {:ok, %{"uid" => "new"}} =
             StreamWatermarkProfile.create(client, "acc", upload)
  end

  test "delete/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 404}]}}}
    end)

    assert {:error, [%{"code" => 404}]} =
             StreamWatermarkProfile.delete(client, "acc", "missing")
  end
end
