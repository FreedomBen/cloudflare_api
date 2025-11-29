defmodule CloudflareApi.DlpDocumentFingerprintsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpDocumentFingerprints

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches document fingerprints", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/document_fingerprints"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "doc"}]}}}
    end)

    assert {:ok, [%{"id" => "doc"}]} = DlpDocumentFingerprints.list(client, "acc")
  end

  test "create/3 posts params", %{client: client} do
    params = %{"name" => "fingerprint"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/document_fingerprints"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "doc"}}}}
    end)

    assert {:ok, %{"id" => "doc"}} = DlpDocumentFingerprints.create(client, "acc", params)
  end

  test "get/3 fetches a fingerprint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/document_fingerprints/doc"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "doc"}}}}
    end)

    assert {:ok, %{"id" => "doc"}} = DlpDocumentFingerprints.get(client, "acc", "doc")
  end

  test "update/4 posts JSON and handles errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"message" => "bad"}]}}}
    end)

    assert {:error, [%{"message" => "bad"}]} =
             DlpDocumentFingerprints.update(client, "acc", "doc", %{"name" => "x"})
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{}}}}
    end)

    assert {:ok, %{}} = DlpDocumentFingerprints.delete(client, "acc", "doc")
  end

  test "upload_file/4 accepts multipart payloads", %{client: client} do
    multipart =
      Tesla.Multipart.new()
      |> Tesla.Multipart.add_file_content("bytes", "file.pdf", name: "file")

    mock(fn %Tesla.Env{method: :put, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/document_fingerprints/doc"

      assert match?(%Tesla.Multipart{}, body)

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"uploaded" => true}}}}
    end)

    assert {:ok, %{"uploaded" => true}} =
             DlpDocumentFingerprints.upload_file(client, "acc", "doc", multipart)
  end
end
