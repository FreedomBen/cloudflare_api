defmodule CloudflareApi.DlpDatasetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.DlpDatasets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits the datasets collection", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ds"}]}}}
    end)

    assert {:ok, [%{"id" => "ds"}]} = DlpDatasets.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "dataset"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} = DlpDatasets.create(client, "acc", params)
  end

  test "get/3 fetches a dataset", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets/ds"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} = DlpDatasets.get(client, "acc", "ds")
  end

  test "update/4 surfaces Cloudflare errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1234}]}}}
    end)

    assert {:error, [%{"code" => 1234}]} =
             DlpDatasets.update(client, "acc", "ds", %{"name" => "new"})
  end

  test "delete/3 sends DELETE with empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} = DlpDatasets.delete(client, "acc", "ds")
  end

  test "create_version/3 posts to upload helper", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets/ds/upload"

      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"upload" => "ok"}}}}
    end)

    assert {:ok, %{"upload" => "ok"}} = DlpDatasets.create_version(client, "acc", "ds")
  end

  test "upload_version/5 streams raw bytes", %{client: client} do
    data = <<0, 1, 2>>

    mock(fn %Tesla.Env{method: :post, url: url, body: body, headers: headers} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets/ds/upload/3"

      assert body == data
      assert {"content-type", "application/octet-stream"} in headers

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"status" => "ok"}}}}
    end)

    assert {:ok, %{"status" => "ok"}} =
             DlpDatasets.upload_version(client, "acc", "ds", 3, data)
  end

  test "define_columns/5 posts JSON column data", %{client: client} do
    params = %{"columns" => [%{"name" => "email"}]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets/ds/versions/1"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
    end)

    assert {:ok, %{"ok" => true}} =
             DlpDatasets.define_columns(client, "acc", "ds", 1, params)
  end

  test "upload_dataset_column/6 uploads raw binary", %{client: client} do
    data = "value"

    mock(fn %Tesla.Env{url: url, body: body, headers: headers} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/dlp/datasets/ds/versions/1/entries/entry"

      assert body == data
      assert {"content-type", "application/octet-stream"} in headers

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"uploaded" => true}}}}
    end)

    assert {:ok, %{"uploaded" => true}} =
             DlpDatasets.upload_dataset_column(client, "acc", "ds", 1, "entry", data)
  end
end
