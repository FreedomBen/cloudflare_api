defmodule CloudflareApi.IpAccessRulesAccountTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAccessRulesAccount

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits account path with filters", %{client: client} do
    opts = [mode: "block", page: 1]

    mock(fn %Tesla.Env{url: url} = env ->
      assert url
             |> String.starts_with?(
               "https://api.cloudflare.com/client/v4/accounts/acc/firewall/access_rules/rules"
             )

      assert URI.parse(url).query |> URI.decode_query() ==
               %{"mode" => "block", "page" => "1"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = IpAccessRulesAccount.list(client, "acc", opts)
  end

  test "create/3 posts the configuration", %{client: client} do
    params = %{"mode" => "block", "configuration" => %{"target" => "country", "value" => "US"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesAccount.create(client, "acc", params)
  end

  test "get/3 fetches a single rule", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/firewall/access_rules/rules/rule"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} = IpAccessRulesAccount.get(client, "acc", "rule")
  end

  test "update/4 patches the rule", %{client: client} do
    params = %{"notes" => "updated"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesAccount.update(client, "acc", "rule", params)
  end

  test "delete/3 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "rule"}}}}
    end)

    assert {:ok, %{"id" => "rule"}} = IpAccessRulesAccount.delete(client, "acc", "rule")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAccessRulesAccount.list(client, "acc")
  end
end
