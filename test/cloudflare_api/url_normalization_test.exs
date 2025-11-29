defmodule CloudflareApi.UrlNormalizationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UrlNormalization

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 returns config", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"scope" => "incoming"}}}}
    end)

    assert {:ok, %{"scope" => "incoming"}} = UrlNormalization.get(client, "zone")
  end

  test "update/3 puts payload", %{client: client} do
    params = %{"type" => "cloudflare"}

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = UrlNormalization.update(client, "zone", params)
  end

  test "delete/2 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 88}]}}}
    end)

    assert {:error, [%{"code" => 88}]} = UrlNormalization.delete(client, "zone")
  end
end
