defmodule CloudflareApi.WarpTeamsDeviceApiOtherTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WarpTeamsDeviceApiOther

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "get_override_codes/3 fetches codes", %{client: client} do
    result = %{"disable_for_time" => %{"minutes_15" => "ABC123"}}

    mock(fn %Tesla.Env{method: :get} = env ->
      assert url(env) ==
               "/accounts/acc/devices/registrations/reg%2F123/override_codes"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => result}}}
    end)

    assert {:ok, ^result} =
             WarpTeamsDeviceApiOther.get_override_codes(client, "acc", "reg/123")
  end

  test "errors bubble up", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 1}]}}}
    end)

    assert {:error, [_]} =
             WarpTeamsDeviceApiOther.get_override_codes(client, "acc", "reg")
  end

  defp url(%Tesla.Env{url: url}), do: String.replace_prefix(url, @base, "")
end
