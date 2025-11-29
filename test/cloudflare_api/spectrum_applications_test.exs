defmodule CloudflareApi.SpectrumApplicationsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.SpectrumApplications

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 appends query params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/zones/zone/spectrum/apps?page=2&per_page=10"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"protocol" => "tcp"}]}}}
    end)

    assert {:ok, [%{"protocol" => "tcp"}]} =
             SpectrumApplications.list(client, "zone", page: 2, per_page: 10)
  end

  test "create/3 posts JSON payload", %{client: client} do
    params = %{"protocol" => "tcp", "origin_dns" => %{"name" => "origin"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = SpectrumApplications.create(client, "zone", params)
  end

  test "delete/3 surfaces server errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1341}]}}}
    end)

    assert {:error, [%{"code" => 1341}]} = SpectrumApplications.delete(client, "zone", "app")
  end
end
