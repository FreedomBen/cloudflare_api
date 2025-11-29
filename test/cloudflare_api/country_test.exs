defmodule CloudflareApi.CountryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Country

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches country data", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/countries"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"code" => "US"}]}
       }}
    end)

    assert {:ok, [%{"code" => "US"}]} = Country.list(client, "acc")
  end
end
