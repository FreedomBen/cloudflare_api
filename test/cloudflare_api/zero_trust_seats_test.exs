defmodule CloudflareApi.ZeroTrustSeatsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.ZeroTrustSeats

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "update/3 sends JSON body", %{client: client} do
    params = %{"seat_uid" => "user"}

    mock(fn %Tesla.Env{method: :patch, url: url, body: body} = env ->
      assert url == @base <> "/accounts/acc/access/seats"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = ZeroTrustSeats.update(client, "acc", params)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} = ZeroTrustSeats.update(client, "acc", %{})
  end
end
