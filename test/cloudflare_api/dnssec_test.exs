defmodule CloudflareApi.DnssecTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Dnssec

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "details/2 fetches DNSSEC info", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/dnssec"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "active"}}}}
    end)

    assert {:ok, %{"status" => "active"}} = Dnssec.details(client, "zone")
  end

  test "delete/2 sends empty object body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = Dnssec.delete(client, "zone")
  end

  test "update/3 handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} =
             Dnssec.update(client, "zone", %{"status" => "disabled"})
  end
end
