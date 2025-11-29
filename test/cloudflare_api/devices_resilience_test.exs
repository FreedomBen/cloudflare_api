defmodule CloudflareApi.DevicesResilienceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DevicesResilience

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_override/2 fetches global state", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/devices/resilience/disconnect"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"enabled" => true}}}}
    end)

    assert {:ok, %{"enabled" => true}} =
             DevicesResilience.get_override(client, "acc")
  end

  test "set_override/3 posts JSON", %{client: client} do
    params = %{"enabled" => false}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             DevicesResilience.set_override(client, "acc", params)
  end
end
