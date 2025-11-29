defmodule CloudflareApi.DiagnosticsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Diagnostics

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "traceroute/3 posts params", %{client: client} do
    params = %{"hostname" => "example.com"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/diagnostics/traceroute"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 202, body: %{"result" => %{"job_id" => "job"}}}}
    end)

    assert {:ok, %{"job_id" => "job"}} =
             Diagnostics.traceroute(client, "acc", params)
  end

  test "traceroute/3 returns Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             Diagnostics.traceroute(client, "acc", %{"hostname" => "bad"})
  end
end
