defmodule CloudflareApi.UserSubscriptionTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserSubscription

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/2 hits subscriptions endpoint", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "sub"}]}}}
    end)

    assert {:ok, [%{"id" => "sub"}]} = UserSubscription.list(client)
  end

  test "update/3 puts payload and delete handles errors", %{client: client} do
    params = %{"enabled" => false}

    mock(fn
      %Tesla.Env{method: :put, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:ok, ^params} = UserSubscription.update(client, "sub", params)
    assert {:error, [%{"code" => 1002}]} = UserSubscription.delete(client, "sub")
  end
end
