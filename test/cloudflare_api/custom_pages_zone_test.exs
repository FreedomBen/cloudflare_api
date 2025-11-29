defmodule CloudflareApi.CustomPagesZoneTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CustomPagesZone

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches zone pages", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/custom_pages"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "always_online"}]}
       }}
    end)

    assert {:ok, [_]} = CustomPagesZone.list(client, "zone")
  end

  test "update/4 sends JSON payload", %{client: client} do
    params = %{"state" => "customized", "url" => "https://example.com/500.html"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CustomPagesZone.update(client, "zone", "500_errors", params)
  end
end
