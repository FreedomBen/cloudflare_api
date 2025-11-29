defmodule CloudflareApi.CloudflareImagesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareImages

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_v1/3 encodes pagination opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1?page=2&per_page=20"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "img"}]}
       }}
    end)

    assert {:ok, [_]} = CloudflareImages.list_v1(client, "acc", page: 2, per_page: 20)
  end

  test "upload/3 accepts multipart payload", %{client: client} do
    multipart =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file_content("bytes", "image.png", name: "file")

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/images/v1"
      assert match?(%Tesla.Multipart{}, body)

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "img"}}
       }}
    end)

    assert {:ok, %{"id" => "img"}} = CloudflareImages.upload(client, "acc", multipart)
  end

  test "delete/3 bubbles up errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1/img"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "missing"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "missing"}]} =
             CloudflareImages.delete(client, "acc", "img")
  end

  test "create_direct_upload_v2/3 hits v2 endpoint", %{client: client} do
    multipart =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("requireSignedURLs", "true")

    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v2/direct_upload"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"uploadURL" => "https://..."}}
       }}
    end)

    assert {:ok, %{"uploadURL" => _}} =
             CloudflareImages.create_direct_upload_v2(client, "acc", multipart)
  end
end
