defmodule CloudflareApi.EmailSecurityTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EmailSecurity

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_messages/3 hits investigate endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/investigate?status=quarantined"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "postfix"}]}}}
    end)

    assert {:ok, [_]} =
             EmailSecurity.list_messages(client, "acc", status: "quarantined")
  end

  test "get_message/3 fetches message detail", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/investigate/msg"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "msg"}}}}
    end)

    assert {:ok, %{"id" => "msg"}} = EmailSecurity.get_message(client, "acc", "msg")
  end

  test "move_message/4 posts params", %{client: client} do
    params = %{"target_folder" => "inbox"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"moved" => true}}}}
    end)

    assert {:ok, %{"moved" => true}} =
             EmailSecurity.move_message(client, "acc", "msg", params)
  end

  test "preview_messages/3 handles Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             EmailSecurity.preview_messages(client, "acc", %{"ids" => ["msg"]})
  end

  test "list_submissions/3 hits submissions endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/email-security/submissions?per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = EmailSecurity.list_submissions(client, "acc", per_page: 10)
  end
end
