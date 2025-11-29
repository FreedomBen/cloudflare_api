defmodule CloudflareApi.ZeroTrustCertificatesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustCertificates

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches certificates", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/gateway/certificates"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "cert"}]}}}
    end)

    assert {:ok, [_]} = ZeroTrustCertificates.list(client, "acc")
  end

  test "create/3 posts JSON", %{client: client} do
    params = %{"name" => "cert"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) ==
               "/accounts/acc/gateway/certificates"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             ZeroTrustCertificates.create(client, "acc", params)
  end

  test "delete/4 includes body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/gateway/certificates/cert%2F1"

      assert Jason.decode!(body) == %{"force" => true}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustCertificates.delete(client, "acc", "cert/1", %{"force" => true})
  end

  test "get/3 fetches certificate", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/gateway/certificates/cert%2F1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "cert/1"}}}}
    end)

    assert {:ok, %{"id" => "cert/1"}} =
             ZeroTrustCertificates.get(client, "acc", "cert/1")
  end

  test "activate/deactivate post JSON", %{client: client} do
    params = %{"rotation" => "immediate"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/gateway/certificates/cert/activate"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustCertificates.activate(client, "acc", "cert", params)

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/gateway/certificates/cert/deactivate"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} =
             ZeroTrustCertificates.deactivate(client, "acc", "cert", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 14}]}}}
    end)

    assert {:error, [_]} = ZeroTrustCertificates.list(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
