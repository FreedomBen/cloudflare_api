defmodule CloudflareApi.CustomHostnamesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomHostnames

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_hostnames?hostname=app.example.com&per_page=5"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"hostname" => "app.example.com"}]}
       }}
    end)

    assert {:ok, [_]} =
             CustomHostnames.list(client, "zone", hostname: "app.example.com", per_page: 5)
  end

  test "create/3 posts JSON payload", %{client: client} do
    params = %{"hostname" => "app.example.com", "ssl" => %{"method" => "http"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = CustomHostnames.create(client, "zone", params)
  end

  test "delete_certificate/5 hits nested path", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_hostnames/host/certificate_pack/pack/certificates/cert"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert"}}}}
    end)

    assert {:ok, %{"id" => "cert"}} =
             CustomHostnames.delete_certificate(client, "zone", "host", "pack", "cert")
  end

  test "update_certificate/6 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{method: :put} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 422,
           body: %{"errors" => [%{"code" => 2001, "message" => "invalid"}]}
       }}
    end)

    assert {:error, [%{"code" => 2001, "message" => "invalid"}]} =
             CustomHostnames.update_certificate(client, "zone", "host", "pack", "cert", %{})
  end
end
