defmodule CloudflareApi.AttackerTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Attacker

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes query options", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/attackers?severity=high"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"attacker_id" => "abc"}]}
       }}
    end)

    assert {:ok, [%{"attacker_id" => "abc"}]} =
             Attacker.list(client, "acc", severity: "high")
  end

  test "list/3 returns API errors untouched", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 500,
           body: %{"errors" => [%{"code" => 9000, "message" => "boom"}]}
       }}
    end)

    assert {:error, [%{"code" => 9000, "message" => "boom"}]} = Attacker.list(client, "acc")
  end
end
