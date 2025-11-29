defmodule CloudflareApi.DomainSearchTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DomainSearch

  @base "https://api.cloudflare.com/client/v4/accounts/acct/brand-protection"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "domain search endpoints map correctly", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      case String.replace_prefix(env.url, @base, "") do
        "/matches?page=1" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/matches/download" ->
          {:ok, %Tesla.Env{env | status: 200, body: "csv"}}

        "/queries" when env.method == :get ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/queries" when env.method == :post ->
          assert Jason.decode!(env.body) == %{"query" => "foo"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "1"}}}}

        "/queries" when env.method == :patch ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/queries" when env.method == :delete ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/queries/bulk" ->
          assert Jason.decode!(env.body) == %{"items" => []}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/search" ->
          assert Jason.decode!(env.body) == %{"query" => "foo"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/total-queries" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => 10}}}
      end
    end)

    assert {:ok, []} = DomainSearch.list_matches(client, "acct", page: 1)
    assert {:ok, "csv"} = DomainSearch.download_matches(client, "acct")
    assert {:ok, []} = DomainSearch.list_queries(client, "acct")

    assert {:ok, %{"id" => "1"}} =
             DomainSearch.create_query(client, "acct", %{"query" => "foo"})

    assert {:ok, %{}} = DomainSearch.update_queries(client, "acct", %{"query" => "bar"})
    assert {:ok, %{}} = DomainSearch.delete_queries(client, "acct")
    assert {:ok, %{}} = DomainSearch.bulk_create_queries(client, "acct", %{"items" => []})
    assert {:ok, []} = DomainSearch.search(client, "acct", %{"query" => "foo"})
    assert {:ok, 10} = DomainSearch.total_queries(client, "acct")
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} =
             DomainSearch.list_matches(client, "acct")
  end
end
