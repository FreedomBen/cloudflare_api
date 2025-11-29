defmodule CloudflareApi.GitHubIntegrationTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.GitHubIntegration

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "config_autofill/5 hits the repo path", %{client: client} do
    mock(fn %Tesla.Env{method: :get, url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/builds/repos/github/123/abc/config_autofill"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"config" => %{}}}}}
    end)

    assert {:ok, %{"config" => %{}}} =
             GitHubIntegration.config_autofill(client, "acc", "github", "123", "abc")
  end

  test "config_autofill/5 surfaces API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1002}]}}}
    end)

    assert {:error, [%{"code" => 1002}]} =
             GitHubIntegration.config_autofill(client, "acc", "github", "123", "abc")
  end
end
