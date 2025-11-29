defmodule CloudflareApi.WorkersAiFinetuneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WorkersAiFinetune

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_finetunes/2 fetches account finetunes", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/ai/finetunes"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = WorkersAiFinetune.list_finetunes(client, "acc")
  end

  test "create_finetune/3 sends JSON body", %{client: client} do
    params = %{"dataset" => "kv"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = WorkersAiFinetune.create_finetune(client, "acc", params)
  end

  test "list_public_finetunes/3 encodes options", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/finetunes/public?limit=10&orderBy=created"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} =
             WorkersAiFinetune.list_public_finetunes(client, "acc",
               limit: 10,
               orderBy: "created"
             )
  end

  test "upload_finetune_asset/4 forwards multipart body", %{client: client} do
    body =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_field("file", "contents")

    mock(fn %Tesla.Env{method: :post, url: url, body: req_body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/ai/finetunes/finetune-1/finetune-assets"

      assert req_body == body
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             WorkersAiFinetune.upload_finetune_asset(client, "acc", "finetune-1", body)
  end

  test "handles finetune errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} = WorkersAiFinetune.list_finetunes(client, "acc")
  end
end
