defmodule CloudflareApi.CredentialManagementTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.CredentialManagement

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "store/4 posts credentials", %{client: client} do
    params = %{"token" => "secret"}

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/r2-catalog/bucket/credential"

      assert Jason.decode!(body) == params

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} =
             CredentialManagement.store(client, "acc", "bucket", params)
  end
end
