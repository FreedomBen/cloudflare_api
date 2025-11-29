defmodule CloudflareApi.Workers do
  @moduledoc ~S"""
  Covers the Workers service API (`/accounts/:account_id/workers/workers`) plus
  build metadata under `/accounts/:account_id/builds/workers/:external_script_id`.
  """

  @doc ~S"""
  List builds for a script (`GET .../builds`).

  Supports `:page` and `:per_page` in `opts`.
  """
  def list_builds_by_script(client, account_id, external_script_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(builds_path(account_id, external_script_id) <> "/builds", opts))
    |> handle_response()
  end

  @doc ~S"""
  List triggers for a script (`GET .../triggers`).
  """
  def list_triggers_by_script(client, account_id, external_script_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(builds_path(account_id, external_script_id) <> "/triggers", opts))
    |> handle_response()
  end

  @doc ~S"""
  List Workers services (`GET /accounts/:account_id/workers/workers`).
  """
  def list_workers(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(workers_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a Worker service (`POST /accounts/:account_id/workers/workers`).
  """
  def create_worker(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(workers_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a Worker service (`DELETE /accounts/:account_id/workers/workers/:worker_id`).
  """
  def delete_worker(client, account_id, worker_id) do
    c(client)
    |> Tesla.delete(worker_path(account_id, worker_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch a Worker service (`GET /accounts/:account_id/workers/workers/:worker_id`).
  """
  def get_worker(client, account_id, worker_id) do
    c(client)
    |> Tesla.get(worker_path(account_id, worker_id))
    |> handle_response()
  end

  @doc ~S"""
  Patch a Worker service (`PATCH .../workers/:worker_id`).
  """
  def patch_worker(client, account_id, worker_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(worker_path(account_id, worker_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace a Worker service (`PUT .../workers/:worker_id`).
  """
  def update_worker(client, account_id, worker_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(worker_path(account_id, worker_id), params)
    |> handle_response()
  end

  defp builds_path(account_id, external_script_id),
    do: "/accounts/#{account_id}/builds/workers/#{encode(external_script_id)}"

  defp workers_path(account_id), do: "/accounts/#{account_id}/workers/workers"

  defp worker_path(account_id, worker_id),
    do: workers_path(account_id) <> "/#{encode(worker_id)}"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
