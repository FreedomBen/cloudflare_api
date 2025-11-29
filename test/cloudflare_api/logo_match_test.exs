defmodule CloudflareApi.LogoMatchTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.LogoMatch

  @base "https://api.cloudflare.com/client/v4/accounts/acct/brand-protection"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "logo match endpoints map correctly", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      path =
        if String.starts_with?(env.url, @base) do
          String.replace_prefix(env.url, @base, "")
        else
          env.url
        end

      cond do
        env.method == :get and path == "/logo-matches?page=1" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :get and path == "/logo-matches/download" ->
          {:ok, %Tesla.Env{env | status: 200, body: "binary"}}

        env.method == :get and path == "/logos" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        env.method == :post and path == "/logos" ->
          assert Jason.decode!(env.body) == %{"name" => "Logo"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "logo"}}}}

        env.method == :get and path == "/logos/logo" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "logo"}}}}

        env.method == :delete and path == "/logos/logo" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :post and path == "/scan-logo" ->
          assert Jason.decode!(env.body) == %{"logo_id" => "logo"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :post and path == "/scan-page" ->
          assert Jason.decode!(env.body) == %{"url" => "https://example.com"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        env.method == :get and path == "https://api.cloudflare.com/client/v4/signed-url" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "signed"}}}
      end
    end)

    assert {:ok, []} = LogoMatch.list_logo_matches(client, "acct", page: 1)
    assert {:ok, "binary"} = LogoMatch.download_logo_matches(client, "acct")
    assert {:ok, []} = LogoMatch.list_logos(client, "acct")

    assert {:ok, %{"id" => "logo"}} =
             LogoMatch.create_logo(client, "acct", %{"name" => "Logo"})

    assert {:ok, %{"id" => "logo"}} = LogoMatch.get_logo(client, "acct", "logo")
    assert {:ok, %{}} = LogoMatch.delete_logo(client, "acct", "logo")
    assert {:ok, %{}} = LogoMatch.scan_logo(client, "acct", %{"logo_id" => "logo"})
    assert {:ok, %{}} = LogoMatch.scan_page(client, "acct", %{"url" => "https://example.com"})
    assert {:ok, "signed"} = LogoMatch.signed_url(client)
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 200}]}}}
    end)

    assert {:error, [%{"code" => 200}]} =
             LogoMatch.list_logo_matches(client, "acct")
  end
end
