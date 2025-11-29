defmodule CloudflareApi.CloudflareImagesVariantsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CloudflareImagesVariants

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches variants", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/images/v1/variants"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "public"}]}
       }}
    end)

    assert {:ok, [%{"id" => "public"}]} = CloudflareImagesVariants.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"id" => "thumb", "options" => %{"width" => 100}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CloudflareImagesVariants.create(client, "acc", params)
  end

  test "delete/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4040, "message" => "missing"}]}
       }}
    end)

    assert {:error, [%{"code" => 4040, "message" => "missing"}]} =
             CloudflareImagesVariants.delete(client, "acc", "variant")
  end
end
