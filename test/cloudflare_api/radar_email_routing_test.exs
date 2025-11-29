defmodule CloudflareApi.RadarEmailRoutingTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarEmailRouting

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary/3 encodes dimension", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/email/routing/summary/dkim"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "dkim"}]}}}
    end)

    assert {:ok, [%{"dimension" => "dkim"}]} = RadarEmailRouting.summary(client, "dkim")
  end

  test "timeseries_group/3 includes query opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/email/routing/timeseries_groups/spf?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "spf"}]}}}
    end)

    assert {:ok, [%{"dimension" => "spf"}]} =
             RadarEmailRouting.timeseries_group(client, "spf", page: 2)
  end

  test "summary/3 handles API errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 77}]}}}
    end)

    assert {:error, [%{"code" => 77}]} = RadarEmailRouting.summary(client, "bad")
  end
end
