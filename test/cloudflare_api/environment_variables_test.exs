defmodule CloudflareApi.EnvironmentVariablesTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.EnvironmentVariables

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "list/4 fetches variables", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/triggers/trig/environment_variables"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"vars" => %{}}}}}
    end)

    assert {:ok, %{"vars" => %{}}} = EnvironmentVariables.list(client, "acc", "trig")
  end

  test "upsert/4 patches JSON", %{client: client} do
    params = %{"KEY" => "VALUE"}

    mock(fn %Tesla.Env{method: :patch, body: body} = env ->
      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             EnvironmentVariables.upsert(client, "acc", "trig", params)
  end

  test "delete/4 sends empty JSON", %{client: client} do
    mock(fn %Tesla.Env{method: :delete, body: body} = env ->
      assert Jason.decode!(body) == %{}
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"deleted" => true}}}}
    end)

    assert {:ok, %{"deleted" => true}} =
             EnvironmentVariables.delete(client, "acc", "trig", "KEY")
  end
end
