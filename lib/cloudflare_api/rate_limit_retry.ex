defmodule CloudflareApi.RateLimitRetry do
  @moduledoc ~S"""
  Retry helper for handling Cloudflare `429` rate-limit responses.

  This module can be used directly to wrap an individual request or as a
  Tesla middleware when building a client:

      client = CloudflareApi.new("token", rate_limit_retry: true)
      {:ok, %Tesla.Env{status: 200}} = Tesla.get(client, "/zones")

  You can also call `run/2` around a specific request:

      CloudflareApi.RateLimitRetry.run(
        fn -> Tesla.get(client, "/zones") end,
        max_retries: 2,
        sleep: fn _ -> :ok end
      )

  Retries are bounded (`max_retries`), default to idempotent methods, and honor
  the `Retry-After` header when Cloudflare provides it.
  """

  @behaviour Tesla.Middleware

  @idempotent_methods ~w(get head options put delete trace)a

  @default_opts [
    max_retries: 2,
    base_backoff: 500,
    max_backoff: 5_000,
    jitter: 0.2,
    retry_non_idempotent: false,
    sleep: &Process.sleep/1
  ]

  @impl true
  def call(env, next, opts) do
    opts = prepare_opts(opts)
    run(fn -> Tesla.run(env, next) end, opts)
  end

  @doc """
  Execute `request_fun` and retry on `429` responses using the provided options.

  `request_fun` should return the same shape as Tesla calls
  (`{:ok, %Tesla.Env{}} | {:error, term}`).
  """
  def run(request_fun, opts \\ []) when is_function(request_fun, 0) do
    opts = prepare_opts(opts)
    do_run(request_fun, opts, 0)
  end

  defp do_run(request_fun, opts, attempt) do
    case request_fun.() do
      {:ok, %Tesla.Env{status: 429} = env} = response ->
        if retry?(env, opts, attempt) do
          opts.sleep.(retry_delay_ms(env, opts, attempt))
          do_run(request_fun, opts, attempt + 1)
        else
          response
        end

      other ->
        other
    end
  end

  defp retry?(%Tesla.Env{method: method}, opts, attempt) do
    attempt < opts.max_retries and
      (opts.retry_non_idempotent || idempotent_method?(method))
  end

  defp idempotent_method?(method) when method in @idempotent_methods, do: true
  defp idempotent_method?(_method), do: false

  defp retry_delay_ms(env, opts, attempt) do
    retry_after_ms(env) || backoff_ms(opts, attempt)
  end

  defp retry_after_ms(%Tesla.Env{headers: headers}) do
    headers
    |> List.wrap()
    |> Enum.find_value(fn
      {name, value} ->
        if String.downcase(to_string(name)) == "retry-after" do
          parse_retry_after(value)
        end

      _ ->
        nil
    end)
  end

  defp parse_retry_after(value) when is_integer(value), do: max(value * 1_000, 0)

  defp parse_retry_after(value) when is_binary(value) do
    value
    |> String.trim()
    |> Integer.parse()
    |> case do
      {seconds, ""} -> max(seconds * 1_000, 0)
      _ -> nil
    end
  end

  defp parse_retry_after(_), do: nil

  defp backoff_ms(opts, attempt) do
    scaled = trunc(opts.base_backoff * :math.pow(2, attempt))
    capped = min(scaled, opts.max_backoff)
    capped + jitter_ms(capped, opts.jitter)
  end

  defp jitter_ms(_base, jitter) when jitter <= 0, do: 0

  defp jitter_ms(base, jitter) do
    # bounded jitter to reduce stampedes
    round(:rand.uniform() * base * jitter)
  end

  defp prepare_opts(opts) when is_map(opts), do: opts

  defp prepare_opts(opts) when is_list(opts) do
    merged = Keyword.merge(@default_opts, opts)

    %{
      max_retries: Keyword.fetch!(merged, :max_retries),
      base_backoff: Keyword.fetch!(merged, :base_backoff),
      max_backoff: Keyword.fetch!(merged, :max_backoff),
      jitter: Keyword.fetch!(merged, :jitter),
      retry_non_idempotent: Keyword.fetch!(merged, :retry_non_idempotent),
      sleep: Keyword.fetch!(merged, :sleep)
    }
  end
end
