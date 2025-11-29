defmodule CloudflareApi.RadarAiInferenceTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RadarAiInference

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "summary_by_model/2 hits model endpoint", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url == "https://api.cloudflare.com/client/v4/radar/ai/inference/summary/model"
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"model" => "foo"}]}}}
    end)

    assert {:ok, [%{"model" => "foo"}]} = RadarAiInference.summary_by_model(client)
  end

  test "timeseries_group/3 encodes dimension and opts", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/radar/ai/inference/timeseries_groups/continent?page=1"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"dimension" => "continent"}]}}}
    end)

    assert {:ok, [%{"dimension" => "continent"}]} =
             RadarAiInference.timeseries_group(client, "continent", page: 1)
  end

  test "summary/3 propagates errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 7}]}}}
    end)

    assert {:error, [%{"code" => 7}]} = RadarAiInference.summary(client, "task")
  end
end
