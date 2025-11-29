defmodule CloudflareApi.D1Test do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.D1

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list_databases/3 encodes filters", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/d1/database?name=app&page=2"

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"name" => "app"}]}
       }}
    end)

    assert {:ok, [_]} = D1.list_databases(client, "acc", name: "app", page: 2)
  end

  test "create_database/3 posts JSON body", %{client: client} do
    params = %{"name" => "db"}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = D1.create_database(client, "acc", params)
  end

  test "query_database/4 posts SQL batch", %{client: client} do
    params = %{"statements" => [%{"sql" => "SELECT 1"}]}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/d1/database/db/query"

      assert Jason.decode!(body) == params

      {:ok,
       %Tesla.Env{
         env
         | status: 200,
           body: %{"result" => [%{"meta" => %{}}]}
       }}
    end)

    assert {:ok, [_]} =
             D1.query_database(client, "acc", "db", params)
  end

  test "export_database/4 handles API errors", %{client: client} do
    mock(fn %Tesla.Env{method: :post} = env ->
      {:ok,
       %Tesla.Env{
         env
         | status: 400,
           body: %{"errors" => [%{"code" => 9000, "message" => "invalid"}]}
       }}
    end)

    assert {:error, [%{"code" => 9000, "message" => "invalid"}]} =
             D1.export_database(client, "acc", "db", %{"output_format" => "polling"})
  end
end
