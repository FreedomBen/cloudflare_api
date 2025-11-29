defmodule CloudflareApi.IpAddressManagementPrefixesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAddressManagementPrefixes

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches prefixes", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAddressManagementPrefixes.list(client, "acc")
  end

  test "create/3 posts prefix payload", %{client: client} do
    params = %{"cidr" => "198.51.100.0/24", "asn" => 64512}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAddressManagementPrefixes.create(client, "acc", params)
  end

  test "update/4 patches description", %{client: client} do
    params = %{"description" => "Updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/pfx"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAddressManagementPrefixes.update(client, "acc", "pfx", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "pfx"}}}}
    end)

    assert {:ok, %{"id" => "pfx"}} = IpAddressManagementPrefixes.delete(client, "acc", "pfx")
  end

  test "validate/3 POSTs empty body and accepts 202", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/prefixes/pfx/validate"

      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 202, body: %{"result" => %{"status" => "pending"}}}}
    end)

    assert {:ok, %{"status" => "pending"}} =
             IpAddressManagementPrefixes.validate(client, "acc", "pfx")
  end

  test "download_loa_document/3 returns raw body", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert env.url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/addressing/loa_documents/doc/download"

      {:ok, %Tesla.Env{env | status: 200, body: "PDFDATA"}}
    end)

    assert {:ok, "PDFDATA"} =
             IpAddressManagementPrefixes.download_loa_document(client, "acc", "doc")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAddressManagementPrefixes.list(client, "acc")
  end
end
