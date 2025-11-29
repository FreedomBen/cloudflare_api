defmodule CloudflareApi.R2AccountTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.R2Account

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "metrics/3 encodes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/accounts/acc/r2/metrics?bucket=b"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"usage" => 10}}}}
    end)

    assert {:ok, %{"usage" => 10}} = R2Account.metrics(client, "acc", bucket: "b")
  end

  test "metrics/3 returns errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [%{"code" => 1}]} = R2Account.metrics(client, "acc")
  end
end
