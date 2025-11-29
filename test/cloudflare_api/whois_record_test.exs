defmodule CloudflareApi.WhoisRecordTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WhoisRecord

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/3 fetches WHOIS data", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/intel/whois?domain=example.com"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"domain" => "example.com"}}}}
    end)

    assert {:ok, %{"domain" => "example.com"}} =
             WhoisRecord.get(client, "acc", domain: "example.com")
  end
end
