defmodule CloudflareApi.InfrastructureAccessTargetsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.InfrastructureAccessTargets

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/3 hits targets endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/infrastructure/targets"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => []}}}
    end)

    assert {:ok, []} = InfrastructureAccessTargets.list(client, "acc")
  end

  test "create/3 posts hostname/ip payload", %{client: client} do
    params = %{"hostname" => "target", "ip" => %{"ipv4" => "192.0.2.1"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = InfrastructureAccessTargets.create(client, "acc", params)
  end

  test "create_targets/3 PUTs array payload", %{client: client} do
    targets = [%{"hostname" => "one", "ip" => %{"ipv4" => "192.0.2.1"}}]

    mock(fn %Tesla.Env{method: :put, body: body} = env ->
      assert Jason.decode!(body) == targets
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => targets}}}
    end)

    assert {:ok, ^targets} =
             InfrastructureAccessTargets.create_targets(client, "acc", targets)
  end

  test "delete_targets/3 posts target_ids", %{client: client} do
    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == %{"target_ids" => ["t1", "t2"]}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => 2}}}}
    end)

    assert {:ok, %{"deleted" => 2}} =
             InfrastructureAccessTargets.delete_targets(client, "acc", ["t1", "t2"])
  end

  test "get_loa/3 returns binary body", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/infrastructure/targets/tgt/loa"

      {:ok, %Tesla.Env{env | status: 200, body: "<<PDF>>"}}
    end)

    assert {:ok, "<<PDF>>"} = InfrastructureAccessTargets.get_loa(client, "acc", "tgt")
  end

  test "handle_response/1 surfaces errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} = InfrastructureAccessTargets.list(client, "acc")
  end
end
