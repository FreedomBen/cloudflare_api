defmodule CloudflareApi.R2SuperSlurper do
  @moduledoc ~S"""
  Manage Super Slurper jobs under `/accounts/:account_id/slurper`.
  """

  def list_jobs(client, account_id, opts \\ []) do
    request(client, :get, with_query(jobs_base(account_id), opts))
  end

  def create_job(client, account_id, params) when is_map(params) do
    request(client, :post, jobs_base(account_id), params)
  end

  def abort_all_jobs(client, account_id, params \\ %{}) when is_map(params) do
    request(client, :put, jobs_base(account_id) <> "/abortAll", params)
  end

  def get_job(client, account_id, job_id) do
    request(client, :get, job_path(account_id, job_id))
  end

  def abort_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/abort", params)
  end

  def pause_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/pause", params)
  end

  def resume_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/resume", params)
  end

  def job_logs(client, account_id, job_id, opts \\ []) do
    request(client, :get, with_query(job_path(account_id, job_id) <> "/logs", opts))
  end

  def job_progress(client, account_id, job_id, opts \\ []) do
    request(client, :get, with_query(job_path(account_id, job_id) <> "/progress", opts))
  end

  def check_source(client, account_id, params) when is_map(params) do
    request(client, :put, "/accounts/#{account_id}/slurper/source/connectivity-precheck", params)
  end

  def check_target(client, account_id, params) when is_map(params) do
    request(client, :put, "/accounts/#{account_id}/slurper/target/connectivity-precheck", params)
  end

  defp jobs_base(account_id), do: "/accounts/#{account_id}/slurper/jobs"
  defp job_path(account_id, job_id), do: jobs_base(account_id) <> "/#{encode(job_id)}"

  defp request(client_or_fun, method, url, body \\ nil) do
    client = c(client_or_fun)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
      end

    handle_response(result)
  end

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

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
