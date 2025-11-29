defmodule CloudflareApi.DatasetTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Dataset

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 fetches datasets", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "ds"}]}}}
    end)

    assert {:ok, [_]} = Dataset.list(client, "acc")
  end

  test "create/3 posts JSON body", %{client: client} do
    params = %{"name" => "dataset"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/create"

      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} = Dataset.create(client, "acc", params)
  end

  test "get/3 retrieves dataset", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} = Dataset.get(client, "acc", "ds")
  end

  test "update/4 uses PATCH", %{client: client} do
    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == %{"name" => "new"}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} =
             Dataset.update(client, "acc", "ds", %{"name" => "new"})
  end

  test "update_alt/4 uses POST", %{client: client} do
    mock(fn %Tesla.Env{method: :post, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/dataset/ds"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => "ds"}}}}
    end)

    assert {:ok, %{"id" => "ds"}} =
             Dataset.update_alt(client, "acc", "ds", %{"name" => "new"})
  end

  test "populate/3 posts to datasets/populate", %{client: client} do
    params = %{"dataset_id" => "ds"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/cloudforce-one/events/datasets/populate"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 202, body: %{"result" => %{"job_id" => "job"}}}}
    end)

    assert {:ok, %{"job_id" => "job"}} = Dataset.populate(client, "acc", params)
  end

  test "delete/3 sends empty body", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} = Dataset.delete(client, "acc", "ds")
  end
end
