defmodule CloudflareApi.RateLimitRetryTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.RateLimitRetry

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "retries a 429 using the Retry-After header", %{client: client} do
    mock(fn
      %Tesla.Env{url: "https://api.cloudflare.com/client/v4/zones"} = env ->
        case Process.get(:seen) do
          nil ->
            Process.put(:seen, true)

            {:ok,
             %Tesla.Env{
               env
               | status: 429,
                 headers: [{"Retry-After", "1"}],
                 body: %{"errors" => [%{"code" => 2001, "message" => "Rate limit exceeded"}]}
             }}

          _ ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "ok"}}}
        end
    end)

    assert {:ok, %Tesla.Env{status: 200}} =
             RateLimitRetry.run(
               fn -> Tesla.get(client, "/zones") end,
               max_retries: 1,
               sleep: fn ms -> send(self(), {:slept, ms}) end
             )

    assert_received {:slept, 1_000}
  end

  test "falls back to exponential backoff when Retry-After is missing", %{client: client} do
    mock(fn
      %Tesla.Env{} = env ->
        case Process.get(:seen) do
          nil ->
            Process.put(:seen, true)
            {:ok, %Tesla.Env{env | status: 429, headers: []}}

          _ ->
            {:ok, %Tesla.Env{env | status: 200}}
        end
    end)

    assert {:ok, %Tesla.Env{status: 200}} =
             RateLimitRetry.run(
               fn -> Tesla.get(client, "/zones?page=1") end,
               max_retries: 1,
               base_backoff: 10,
               max_backoff: 20,
               jitter: 0,
               sleep: fn ms -> send(self(), {:slept, ms}) end
             )

    assert_received {:slept, 10}
  end

  test "does not retry non-idempotent methods by default", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 429}}
    end)

    assert {:ok, %Tesla.Env{status: 429}} =
             RateLimitRetry.run(
               fn -> Tesla.post(client, "/zones", %{}) end,
               max_retries: 2,
               sleep: fn ms -> send(self(), {:slept, ms}) end
             )

    refute_received {:slept, _}
  end

  test "stops after max_retries", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 429, headers: []}}
    end)

    assert {:ok, %Tesla.Env{status: 429}} =
             RateLimitRetry.run(
               fn -> Tesla.get(client, "/zones") end,
               max_retries: 2,
               base_backoff: 1,
               jitter: 0,
               sleep: fn ms -> send(self(), {:slept, ms}) end
             )

    assert_received {:slept, 1}
    assert_received {:slept, 2}
    refute_received {:slept, _}
  end

  test "middleware integration retries automatically" do
    client =
      CloudflareApi.new("token",
        rate_limit_retry: [
          max_retries: 1,
          jitter: 0,
          base_backoff: 0,
          sleep: fn ms -> send(self(), {:slept, ms}) end
        ]
      )

    mock(fn
      %Tesla.Env{} = env ->
        case Process.get(:seen) do
          nil ->
            Process.put(:seen, true)
            {:ok, %Tesla.Env{env | status: 429}}

          _ ->
            {:ok, %Tesla.Env{env | status: 200, body: %{"result" => "ok"}}}
        end
    end)

    assert {:ok, %Tesla.Env{status: 200}} = Tesla.get(client, "/zones")
    assert_received {:slept, 0}
  end

  test "no retries occur when middleware is not enabled", %{client: client} do
    Process.put(:calls, 0)

    mock(fn %Tesla.Env{} = env ->
      Process.put(:calls, Process.get(:calls) + 1)
      {:ok, %Tesla.Env{env | status: 429}}
    end)

    assert {:ok, %Tesla.Env{status: 429}} = Tesla.get(client, "/zones")
    assert Process.get(:calls) == 1
  end
end
