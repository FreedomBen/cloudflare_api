defmodule CloudflareApi.WarpChangeEventsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WarpChangeEvents

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dex/warp-change-events?per_page=5"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "evt"}]}}}
    end)

    assert {:ok, [%{"id" => "evt"}]} =
             WarpChangeEvents.list(client, "acc", per_page: 5)
  end
end
