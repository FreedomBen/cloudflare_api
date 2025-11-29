defmodule CloudflareApi.CustomSslTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomSsl

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_certificates?status=active&per_page=5"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "cert"}]}
       }}
    end)

    assert {:ok, [_]} = CustomSsl.list(client, "zone", status: "active", per_page: 5)
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"certificate" => "PEM", "private_key" => "KEY"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CustomSsl.create(client, "zone", params)
  end

  test "prioritize/3 sends certificate order", %{client: client} do
    params = %{"certificates" => [%{"id" => "a", "priority" => 1}]}

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_certificates/prioritize"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CustomSsl.prioritize(client, "zone", params)
  end

  test "delete/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 409,
           body: %{"errors" => [%{"code" => 1000, "message" => "in use"}]}
       }}
    end)

    assert {:error, [%{"code" => 1000, "message" => "in use"}]} =
             CustomSsl.delete(client, "zone", "cert")
  end
end
