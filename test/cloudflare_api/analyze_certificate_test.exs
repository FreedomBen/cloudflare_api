defmodule CloudflareApi.AnalyzeCertificateTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AnalyzeCertificate

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "analyze/3 posts payload", %{client: client} do
    params = %{"certificate" => "---"}

    mock(fn %Tesla.Env{method: :post, body: body, url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/zones/zone/ssl/analyze"
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"valid" => true}}}}
    end)

    assert {:ok, %{"valid" => true}} = AnalyzeCertificate.analyze(client, "zone", params)
  end
end
