defmodule CloudflareApi.BinDbTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.BinDb

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "upload/3 builds multipart payload", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/binary"

      assert %Tesla.Multipart{parts: [part]} = body
      assert part.body == "BIN"
      assert Keyword.get(part.dispositions, :name) == "file"
      assert Keyword.get(part.dispositions, :filename) == "sample.bin"
      assert {"content-type", "application/octet-stream"} in part.headers

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "hash"}}
       }}
    end)

    file = %{filename: "sample.bin", body: "BIN"}
    assert {:ok, %{"id" => "hash"}} = BinDb.upload(client, "acc", file)
  end

  test "get/3 propagates API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/binary/abcd"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "not found"}]} =
             BinDb.get(client, "acc", "abcd")
  end
end
