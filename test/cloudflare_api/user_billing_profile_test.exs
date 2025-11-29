defmodule CloudflareApi.UserBillingProfileTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.UserBillingProfile

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get/2 fetches billing profile", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"first_name" => "Pat"}}}}
    end)

    assert {:ok, %{"first_name" => "Pat"}} = UserBillingProfile.get(client)
  end
end
