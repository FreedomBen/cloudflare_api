defmodule CloudflareApi.StreamVideoClippingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamVideoClipping

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "clip/3 posts body", %{client: client} do
    params = %{"videoId" => "abc", "startTimeSeconds" => 0, "endTimeSeconds" => 10}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/stream/clip"
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"clipId" => "clip"}}}}
    end)

    assert {:ok, %{"clipId" => "clip"}} = StreamVideoClipping.clip(client, "acc", params)
  end
end
