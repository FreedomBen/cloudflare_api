defmodule CloudflareApi.FeedbackTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Feedback

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits zone feedback endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/bot_management/feedback"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "fb"}]}}}
    end)

    assert {:ok, [_]} = Feedback.list(client, "zone")
  end

  test "create/3 posts report params", %{client: client} do
    params = %{"action" => "allow"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = Feedback.create(client, "zone", params)
  end
end
