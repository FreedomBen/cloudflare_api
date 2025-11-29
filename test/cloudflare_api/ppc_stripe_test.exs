defmodule CloudflareApi.PpcStripeTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.PpcStripe

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_crawler_config/2 hits crawler path", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/accounts/acc/pay-per-crawl/crawler/stripe"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"role" => "crawler"}}}}
    end)

    assert {:ok, %{"role" => "crawler"}} = PpcStripe.get_crawler_config(client, "acc")
  end

  test "create_crawler_config/3 posts payload", %{client: client} do
    payload = %{"code" => "stripe-code"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/pay-per-crawl/crawler/stripe"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"role" => "crawler"}}}}
    end)

    assert {:ok, %{"role" => "crawler"}} =
             PpcStripe.create_crawler_config(client, "acc", payload)
  end

  test "delete_crawler_config/2 issues DELETE", %{client: client} do
    mock(fn %Tesla.Env{method: :delete} = env ->
      assert url(env) == "/accounts/acc/pay-per-crawl/crawler/stripe"
      {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
    end)

    assert {:ok, %{"success" => true}} = PpcStripe.delete_crawler_config(client, "acc")
  end

  test "publisher endpoints reuse same helper", %{client: client} do
    mock(fn
      %Tesla.Env{method: :get} = env ->
        assert url(env) == "/accounts/acc/pay-per-crawl/publisher/stripe"
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"role" => "publisher"}}}}

      %Tesla.Env{method: :post, body: body} = env ->
        assert url(env) == "/accounts/acc/pay-per-crawl/publisher/stripe"
        assert Jason.decode!(body) == %{}
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"role" => "publisher"}}}}

      %Tesla.Env{method: :delete} = env ->
        assert url(env) == "/accounts/acc/pay-per-crawl/publisher/stripe"
        {:ok, %Tesla.Env{env | status: 200, body: %{"success" => true}}}
    end)

    assert {:ok, %{"role" => "publisher"}} = PpcStripe.get_publisher_config(client, "acc")
    assert {:ok, %{"role" => "publisher"}} = PpcStripe.create_publisher_config(client, "acc")
    assert {:ok, %{"success" => true}} = PpcStripe.delete_publisher_config(client, "acc")
  end

  test "errors propagate", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 10}]}}}
    end)

    assert {:error, [_]} = PpcStripe.get_crawler_config(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
