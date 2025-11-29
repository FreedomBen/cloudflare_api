defmodule CloudflareApi.LogpushJobsAccount do
  @moduledoc ~S"""
  Manage account-level Logpush jobs, ownership challenges, and validation helpers.
  """

  def list(client, account_id) do
    request(client, :get, jobs_path(account_id))
  end

  def create(client, account_id, params) when is_map(params) do
    request(client, :post, jobs_path(account_id), params)
  end

  def get(client, account_id, job_id) do
    request(client, :get, job_path(account_id, job_id))
  end

  def update(client, account_id, job_id, params) when is_map(params) do
    request(client, :put, job_path(account_id, job_id), params)
  end

  def delete(client, account_id, job_id) do
    request(client, :delete, job_path(account_id, job_id), %{})
  end

  def list_dataset_jobs(client, account_id, dataset_id) do
    request(client, :get, base(account_id) <> "/datasets/#{dataset_id}/jobs")
  end

  def list_dataset_fields(client, account_id, dataset_id) do
    request(client, :get, base(account_id) <> "/datasets/#{dataset_id}/fields")
  end

  def ownership_challenge(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/ownership", params)
  end

  def validate_ownership(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/ownership/validate", params)
  end

  def validate_destination(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/validate/destination", params)
  end

  def destination_exists?(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/validate/destination/exists", params)
  end

  def validate_origin(client, account_id, params) when is_map(params) do
    request(client, :post, base(account_id) <> "/validate/origin", params)
  end

  defp base(account_id), do: "/accounts/#{account_id}/logpush"
  defp jobs_path(account_id), do: base(account_id) <> "/jobs"
  defp job_path(account_id, job_id), do: jobs_path(account_id) <> "/#{job_id}"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
      end

    handle_response(result)
  end

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
