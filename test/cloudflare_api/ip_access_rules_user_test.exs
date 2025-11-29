defmodule CloudflareApi.IpAccessRulesUserTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.IpAccessRulesUser

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 encodes filters", %{client: client} do
    opts = [mode: "block", "configuration.target": "ip", "configuration.value": "1.1.1.1"]

    mock(fn %Tesla.Env{url: url} = env ->
      assert url
             |> String.starts_with?(
               "https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules"
             )

      assert URI.parse(url).query |> URI.decode_query() ==
               %{
                 "mode" => "block",
                 "configuration.target" => "ip",
                 "configuration.value" => "1.1.1.1"
               }

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "r1"}]}}}
    end)

    assert {:ok, [%{"id" => "r1"}]} = IpAccessRulesUser.list(client, opts)
  end

  test "create/2 posts configuration map", %{client: client} do
    params = %{"mode" => "block", "configuration" => %{"target" => "ip", "value" => "1.1.1.1"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesUser.create(client, params)
  end

  test "update/3 patches the rule", %{client: client} do
    params = %{"notes" => "updated"}

    mock(fn %Tesla.Env{method: :patch, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules/r1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = IpAccessRulesUser.update(client, "r1", params)
  end

  test "delete/2 sends empty JSON body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "r1"}}}}
    end)

    assert {:ok, %{"id" => "r1"}} = IpAccessRulesUser.delete(client, "r1")
  end

  test "handle_response/1 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = IpAccessRulesUser.list(client)
  end
end
