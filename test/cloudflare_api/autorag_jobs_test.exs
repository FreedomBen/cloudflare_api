defmodule CloudflareApi.AutoragJobsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.AutoragJobs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 passes query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags/rag/jobs?limit=2&direction=desc"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"id" => "job"}]}
       }}
    end)

    assert {:ok, [%{"id" => "job"}]} =
             AutoragJobs.list(client, "acc", "rag", limit: 2, direction: "desc")
  end

  test "get/4 fetches a single job", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags/rag/jobs/job"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => %{"id" => "job"}}
       }}
    end)

    assert {:ok, %{"id" => "job"}} = AutoragJobs.get(client, "acc", "rag", "job")
  end

  test "logs/5 bubbles up API errors", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/autorag/rags/rag/jobs/job/logs?cursor=after"

      {:ok,
       %Tesla.Env{
         env
         | status: 404,
           body: %{"errors" => [%{"code" => 4004, "message" => "not found"}]}
       }}
    end)

    assert {:error, [%{"code" => 4004, "message" => "not found"}]} =
             AutoragJobs.logs(client, "acc", "rag", "job", cursor: "after")
  end
end
