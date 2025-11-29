defmodule CloudflareApi.TokenValidationTokenConfigurationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TokenValidationTokenConfiguration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits config collection", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/token_validation/config?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"name" => "cfg"}]}}}
    end)

    assert {:ok, [%{"name" => "cfg"}]} =
             TokenValidationTokenConfiguration.list(client, "zone", per_page: 5)
  end

  test "update/4 patches body and delete handles errors", %{client: client} do
    params = %{"name" => "updated"}

    mock(fn
      %Tesla.Env{method: :patch, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 42}]}}}
    end)

    assert {:ok, ^params} =
             TokenValidationTokenConfiguration.update(client, "zone", "cfg", params)

    assert {:error, [%{"code" => 42}]} =
             TokenValidationTokenConfiguration.delete(client, "zone", "cfg")
  end

  test "update_credentials/4 posts JSON", %{client: client} do
    params = %{"binding" => "kv"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             TokenValidationTokenConfiguration.update_credentials(client, "zone", "cfg", params)
  end
end
