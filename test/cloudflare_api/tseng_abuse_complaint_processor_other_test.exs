defmodule CloudflareApi.TsengAbuseComplaintProcessorOtherTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.TsengAbuseComplaintProcessorOther, as: AbuseReports

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_reports/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url == @base <> "/accounts/acc/abuse-reports?domain=example.com&page=2"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"reports" => []}}}}
    end)

    assert {:ok, %{"reports" => []}} =
             AbuseReports.list_reports(client, "acc", domain: "example.com", page: 2)
  end

  test "get_report/3 encodes path segments", %{client: client} do
    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) == "/accounts/acc/abuse-reports/report%2F123"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "report/123"}}}}
    end)

    assert {:ok, %{"id" => "report/123"}} =
             AbuseReports.get_report(client, "acc", "report/123")
  end

  test "submit_report/4 posts payload", %{client: client} do
    payload = %{"report" => %{"domain" => "example.com"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/abuse-reports/abuse_general"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "queued"}}}}
    end)

    assert {:ok, %{"status" => "queued"}} =
             AbuseReports.submit_report(client, "acc", "abuse_general", payload)
  end

  test "list_mitigations/4 encodes repeated params", %{client: client} do
    opts = [type: ["rate_limit_cache", "legal_block"], status: "active"]

    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               @base <>
                 "/accounts/acc/abuse-reports/report%201/mitigations?type=rate_limit_cache&type=legal_block&status=active"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"mitigations" => []}}}}
    end)

    assert {:ok, %{"mitigations" => []}} =
             AbuseReports.list_mitigations(client, "acc", "report 1", opts)
  end

  test "request_review/4 posts appeal payload", %{client: client} do
    payload = %{"mitigation_ids" => ["mit-1"], "justification" => "resolved"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert url(env) == "/accounts/acc/abuse-reports/report/mitigations/appeal"
      assert Jason.decode!(body) == payload
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "received"}}}}
    end)

    assert {:ok, %{"status" => "received"}} =
             AbuseReports.request_review(client, "acc", "report", payload)
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} = AbuseReports.list_reports(client, "acc")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
