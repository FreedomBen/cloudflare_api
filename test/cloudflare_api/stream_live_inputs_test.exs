defmodule CloudflareApi.StreamLiveInputsTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.StreamLiveInputs

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "create/3 posts params", %{client: client} do
    params = %{"meta" => %{"name" => "input"}}

    mock(fn %Tesla.Env{method: :post, body: body} = env ->
      assert Jason.decode!(body) == params
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}
    end)

    assert {:ok, ^params} = StreamLiveInputs.create(client, "acc", params)
  end

  test "list_outputs/4 encodes params", %{client: client} do
    mock(fn %Tesla.Env{url: url} = env ->
      assert url ==
               "https://api.cloudflare.com/client/v4/accounts/acc/stream/live_inputs/input/outputs?page=2"

      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => [%{"id" => "out"}]}}}
    end)

    assert {:ok, [%{"id" => "out"}]} =
             StreamLiveInputs.list_outputs(client, "acc", "input", page: 2)
  end

  test "update_output/5 patches payload and delete_output handles errors", %{client: client} do
    params = %{"url" => "rtmp://example"}

    mock(fn
      %Tesla.Env{method: :put, body: body} = env ->
        assert Jason.decode!(body) == params
        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => params}}}

      %Tesla.Env{method: :delete} = env ->
        {:ok, %Tesla.Env{env | status: 404, body: %{"errors" => [%{"code" => 2004}]}}}
    end)

    assert {:ok, ^params} =
             StreamLiveInputs.update_output(client, "acc", "input", "output", params)

    assert {:error, [%{"code" => 2004}]} =
             StreamLiveInputs.delete_output(client, "acc", "input", "output")
  end
end
