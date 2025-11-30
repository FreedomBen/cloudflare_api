defmodule CloudflareApi.R2SuperSlurper do
  @moduledoc ~S"""
  Manage Super Slurper jobs under `/accounts/:account_id/slurper`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List jobs for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.list_jobs(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_jobs(client, account_id, opts \\ []) do
    request(client, :get, with_query(jobs_base(account_id), opts))
  end

  @doc ~S"""
  Create job for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.create_job(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_job(client, account_id, params) when is_map(params) do
    request(client, :post, jobs_base(account_id), params)
  end

  @doc ~S"""
  Abort all jobs for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.abort_all_jobs(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def abort_all_jobs(client, account_id, params \\ %{}) when is_map(params) do
    request(client, :put, jobs_base(account_id) <> "/abortAll", params)
  end

  @doc ~S"""
  Get job for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.get_job(client, "account_id", "job_id")
      {:ok, %{"id" => "example"}}

  """

  def get_job(client, account_id, job_id) do
    request(client, :get, job_path(account_id, job_id))
  end

  @doc ~S"""
  Abort job for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.abort_job(client, "account_id", "job_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def abort_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/abort", params)
  end

  @doc ~S"""
  Pause job for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.pause_job(client, "account_id", "job_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def pause_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/pause", params)
  end

  @doc ~S"""
  Resume job for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.resume_job(client, "account_id", "job_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def resume_job(client, account_id, job_id, params \\ %{}) when is_map(params) do
    request(client, :put, job_path(account_id, job_id) <> "/resume", params)
  end

  @doc ~S"""
  Job logs for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.job_logs(client, "account_id", "job_id", [])
      {:ok, %{"id" => "example"}}

  """

  def job_logs(client, account_id, job_id, opts \\ []) do
    request(client, :get, with_query(job_path(account_id, job_id) <> "/logs", opts))
  end

  @doc ~S"""
  Job progress for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.job_progress(client, "account_id", "job_id", [])
      {:ok, %{"id" => "example"}}

  """

  def job_progress(client, account_id, job_id, opts \\ []) do
    request(client, :get, with_query(job_path(account_id, job_id) <> "/progress", opts))
  end

  @doc ~S"""
  Check source for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.check_source(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def check_source(client, account_id, params) when is_map(params) do
    request(client, :put, "/accounts/#{account_id}/slurper/source/connectivity-precheck", params)
  end

  @doc ~S"""
  Check target for r2 super slurper.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.R2SuperSlurper.check_target(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

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
