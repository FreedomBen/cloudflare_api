defmodule CloudflareApi.RadarEmailSecurityTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarEmailSecurity

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 hits summary endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/email/security/summary/spam"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "spam"}]}}}
    end)

    assert {:ok, [%{"dimension" => "spam"}]} = RadarEmailSecurity.summary(client, "spam")
  end

  test "top_tlds_by/4 encodes field/value", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/email/security/top/tlds/spam/high"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"tld" => "com"}]}}}
    end)

    assert {:ok, [%{"tld" => "com"}]} = RadarEmailSecurity.top_tlds_by(client, "spam", "high")
  end

  test "timeseries_group/3 bubbles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 2}]}}}
    end)

    assert {:error, [%{"code" => 2}]} = RadarEmailSecurity.timeseries_group(client, "spf")
  end
end
