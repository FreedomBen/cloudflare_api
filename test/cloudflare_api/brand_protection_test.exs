defmodule CloudflareApi.BrandProtectionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.BrandProtection

  @base "https://api.cloudflare.com/client/v4/accounts/acct/brand-protection"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "alert, brand, and submission endpoints hit expected paths", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      case String.replace_prefix(env.url, @base, "") do
        "/alerts?page=1" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/alerts" when env.method == :patch ->
          assert Jason.decode!(env.body) == %{"ids" => [1]}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/alerts/clear" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/alerts/refute" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/alerts/verify" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/brands" when env.method == :get ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/brands" when env.method == :post ->
          assert Jason.decode!(env.body) == %{"name" => "Brand"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"name" => "Brand"}}}}

        "/brands" when env.method == :delete ->
          assert Jason.decode!(env.body) == %{}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/brands/patterns" when env.method == :get ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/brands/patterns" when env.method == :post ->
          assert Jason.decode!(env.body) == %{"pattern" => "example"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/brands/patterns" when env.method == :delete ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/clear" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/refute" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/verify" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/domain-info?domain=example.com" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/recent-submissions" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/submission-info" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/submit" ->
          assert Jason.decode!(env.body) == %{"domain" => "example.com"}
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        "/tracked-domains" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}

        "/url-info" ->
          {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

        _ ->
          global_endpoint(env)
      end
    end)

    assert {:ok, []} = BrandProtection.list_alerts(client, "acct", page: 1)
    assert {:ok, %{}} = BrandProtection.update_alerts(client, "acct", %{"ids" => [1]})
    assert {:ok, %{}} = BrandProtection.clear_alerts(client, "acct")
    assert {:ok, %{}} = BrandProtection.refute_alerts(client, "acct")
    assert {:ok, %{}} = BrandProtection.verify_alerts(client, "acct")

    assert {:ok, []} = BrandProtection.list_brands(client, "acct")

    assert {:ok, %{"name" => "Brand"}} =
             BrandProtection.create_brand(client, "acct", %{"name" => "Brand"})

    assert {:ok, %{}} = BrandProtection.delete_brands(client, "acct")
    assert {:ok, []} = BrandProtection.list_brand_patterns(client, "acct")

    assert {:ok, %{}} =
             BrandProtection.create_brand_pattern(client, "acct", %{"pattern" => "example"})

    assert {:ok, %{}} = BrandProtection.delete_brand_patterns(client, "acct")
    assert {:ok, %{}} = BrandProtection.clear_submissions(client, "acct")
    assert {:ok, %{}} = BrandProtection.refute_submission(client, "acct")
    assert {:ok, %{}} = BrandProtection.verify_submission(client, "acct")
    assert {:ok, %{}} = BrandProtection.get_domain_info(client, "acct", domain: "example.com")
    assert {:ok, []} = BrandProtection.list_recent_submissions(client, "acct")
    assert {:ok, %{}} = BrandProtection.get_submission_info(client, "acct")
    assert {:ok, %{}} = BrandProtection.submit(client, "acct", %{"domain" => "example.com"})
    assert {:ok, []} = BrandProtection.list_tracked_domains(client, "acct")
    assert {:ok, %{}} = BrandProtection.get_url_info(client, "acct")
    assert {:ok, %{}} = BrandProtection.internal_submit(client, %{})
    assert {:ok, "ok"} = BrandProtection.live(client)
    assert {:ok, "ok"} = BrandProtection.ready(client)
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 99}]}}}
    end)

    assert {:error, [%{"code" => 99}]} =
             BrandProtection.list_alerts(client, "acct")
  end

  defp global_endpoint(
         %Tesla.Env{method: :post, url: "https://api.cloudflare.com/client/v4/internal/submit"} =
           env
       ),
       do: {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}

  defp global_endpoint(
         %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/live"} = env
       ),
       do: {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "ok"}}}

  defp global_endpoint(
         %Tesla.Env{method: :get, url: "https://api.cloudflare.com/client/v4/ready"} = env
       ),
       do: {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "ok"}}}
end
