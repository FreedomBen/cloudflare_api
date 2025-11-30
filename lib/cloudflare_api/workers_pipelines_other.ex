defmodule CloudflareApi.WorkersPipelinesOther do
  @moduledoc ~S"""
  Thin wrappers around the Workers Pipelines endpoints (both deprecated
  `/accounts/:account_id/pipelines` and the newer `/pipelines/v1/...` surface).

  These helpers keep the HTTP surface explicit so callers can manage pipelines,
  sinks, streams, and SQL validation jobs directly from Elixir.
  """

  use CloudflareApi.Typespecs

  ## Deprecated `/pipelines` surface

  @doc ~S"""
  List pipelines via the deprecated `/accounts/:account_id/pipelines` endpoint.
  """
  def list_deprecated(client, account_id, opts \\ []) do
    request(client, :get, with_query(deprecated_base(account_id), opts))
  end

  @doc ~S"""
  Create a pipeline via the deprecated endpoint (`POST /accounts/:account_id/pipelines`).

  Pass a map aligned with the legacy schema (destination, source, etc.).
  """
  def create_deprecated(client, account_id, params) when is_map(params) do
    request(client, :post, deprecated_base(account_id), params)
  end

  @doc ~S"""
  Fetch a single pipeline by name using the deprecated endpoint.
  """
  def get_deprecated(client, account_id, pipeline_name) do
    request(client, :get, deprecated_pipeline_path(account_id, pipeline_name))
  end

  @doc ~S"""
  Replace a pipeline definition via the deprecated endpoint (`PUT .../pipelines/:pipeline_name`).
  """
  def replace_deprecated(client, account_id, pipeline_name, params) when is_map(params) do
    request(client, :put, deprecated_pipeline_path(account_id, pipeline_name), params)
  end

  @doc ~S"""
  Delete a pipeline by name using the deprecated endpoint.
  """
  def delete_deprecated(client, account_id, pipeline_name) do
    request(client, :delete, deprecated_pipeline_path(account_id, pipeline_name))
  end

  ## v1 pipelines

  @doc ~S"""
  List pipelines through `/accounts/:account_id/pipelines/v1/pipelines`.
  """
  def list_pipelines(client, account_id, opts \\ []) do
    request(client, :get, with_query(v1_pipeline_base(account_id), opts))
  end

  @doc ~S"""
  Create a pipeline (`POST /accounts/:account_id/pipelines/v1/pipelines`).
  """
  def create_pipeline(client, account_id, params) when is_map(params) do
    request(client, :post, v1_pipeline_base(account_id), params)
  end

  @doc ~S"""
  Fetch a pipeline by ID (`GET /accounts/:account_id/pipelines/v1/pipelines/:pipeline_id`).
  """
  def get_pipeline(client, account_id, pipeline_id) do
    request(client, :get, v1_pipeline_path(account_id, pipeline_id))
  end

  @doc ~S"""
  Delete a pipeline by ID (`DELETE /accounts/:account_id/pipelines/v1/pipelines/:pipeline_id`).
  """
  def delete_pipeline(client, account_id, pipeline_id) do
    request(client, :delete, v1_pipeline_path(account_id, pipeline_id))
  end

  ## v1 sinks

  @doc ~S"""
  List configured sinks (`GET /accounts/:account_id/pipelines/v1/sinks`).
  """
  def list_sinks(client, account_id, opts \\ []) do
    request(client, :get, with_query(v1_sink_base(account_id), opts))
  end

  @doc ~S"""
  Create a sink (`POST /accounts/:account_id/pipelines/v1/sinks`).
  """
  def create_sink(client, account_id, params) when is_map(params) do
    request(client, :post, v1_sink_base(account_id), params)
  end

  @doc ~S"""
  Fetch sink details (`GET /accounts/:account_id/pipelines/v1/sinks/:sink_id`).
  """
  def get_sink(client, account_id, sink_id) do
    request(client, :get, v1_sink_path(account_id, sink_id))
  end

  @doc ~S"""
  Delete a sink (`DELETE /accounts/:account_id/pipelines/v1/sinks/:sink_id`).
  """
  def delete_sink(client, account_id, sink_id) do
    request(client, :delete, v1_sink_path(account_id, sink_id))
  end

  ## v1 streams

  @doc ~S"""
  List streams (`GET /accounts/:account_id/pipelines/v1/streams`).
  """
  def list_streams(client, account_id, opts \\ []) do
    request(client, :get, with_query(v1_stream_base(account_id), opts))
  end

  @doc ~S"""
  Create a stream (`POST /accounts/:account_id/pipelines/v1/streams`).
  """
  def create_stream(client, account_id, params) when is_map(params) do
    request(client, :post, v1_stream_base(account_id), params)
  end

  @doc ~S"""
  Get a stream definition (`GET /accounts/:account_id/pipelines/v1/streams/:stream_id`).
  """
  def get_stream(client, account_id, stream_id) do
    request(client, :get, v1_stream_path(account_id, stream_id))
  end

  @doc ~S"""
  Update a stream (`PATCH /accounts/:account_id/pipelines/v1/streams/:stream_id`).
  """
  def update_stream(client, account_id, stream_id, params) when is_map(params) do
    request(client, :patch, v1_stream_path(account_id, stream_id), params)
  end

  @doc ~S"""
  Delete a stream (`DELETE /accounts/:account_id/pipelines/v1/streams/:stream_id`).
  """
  def delete_stream(client, account_id, stream_id) do
    request(client, :delete, v1_stream_path(account_id, stream_id))
  end

  ## Validation

  @doc ~S"""
  Validate a SQL statement (`POST /accounts/:account_id/pipelines/v1/validate_sql`).
  """
  def validate_sql(client, account_id, params) when is_map(params) do
    request(client, :post, validate_path(account_id), params)
  end

  defp deprecated_base(account_id), do: "/accounts/#{account_id}/pipelines"

  defp deprecated_pipeline_path(account_id, pipeline_name),
    do: deprecated_base(account_id) <> "/#{encode(pipeline_name)}"

  defp v1_pipeline_base(account_id), do: "/accounts/#{account_id}/pipelines/v1/pipelines"

  defp v1_pipeline_path(account_id, pipeline_id),
    do: v1_pipeline_base(account_id) <> "/#{encode(pipeline_id)}"

  defp v1_sink_base(account_id), do: "/accounts/#{account_id}/pipelines/v1/sinks"

  defp v1_sink_path(account_id, sink_id),
    do: v1_sink_base(account_id) <> "/#{encode(sink_id)}"

  defp v1_stream_base(account_id), do: "/accounts/#{account_id}/pipelines/v1/streams"

  defp v1_stream_path(account_id, stream_id),
    do: v1_stream_base(account_id) <> "/#{encode(stream_id)}"

  defp validate_path(account_id),
    do: "/accounts/#{account_id}/pipelines/v1/validate_sql"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
        :post -> Tesla.post(client, url, body || %{})
        :put -> Tesla.put(client, url, body || %{})
        :patch -> Tesla.patch(client, url, body || %{})
        :delete -> delete(client, url, body)
      end

    handle_response(result)
  end

  defp delete(client, url, nil), do: Tesla.delete(client, url)
  defp delete(client, url, body), do: Tesla.delete(client, url, body: body)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp encode(value), do: value |> to_string() |> URI.encode(&URI.char_unreserved?/1)

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
