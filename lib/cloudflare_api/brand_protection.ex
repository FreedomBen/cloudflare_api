defmodule CloudflareApi.BrandProtection do
  @moduledoc ~S"""
  Brand Protection API helpers under `/accounts/:account_id/brand-protection`.
  """

  ## Alerts

  def list_alerts(client, account_id, opts \\ []) do
    get(client, alerts_path(account_id), opts)
  end

  def update_alerts(client, account_id, params) when is_map(params) do
    patch(client, alerts_path(account_id), params)
  end

  def clear_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/clear", params)
  end

  def refute_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/refute", params)
  end

  def verify_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/verify", params)
  end

  ## Brands & Patterns

  def list_brands(client, account_id, opts \\ []) do
    get(client, brands_path(account_id), opts)
  end

  def create_brand(client, account_id, params) when is_map(params) do
    post(client, brands_path(account_id), params)
  end

  def delete_brands(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, brands_path(account_id), params)
  end

  def list_brand_patterns(client, account_id, opts \\ []) do
    get(client, brands_path(account_id) <> "/patterns", opts)
  end

  def create_brand_pattern(client, account_id, params) when is_map(params) do
    post(client, brands_path(account_id) <> "/patterns", params)
  end

  def delete_brand_patterns(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, brands_path(account_id) <> "/patterns", params)
  end

  ## Submission helpers

  def clear_submissions(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/clear", params)
  end

  def refute_submission(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/refute", params)
  end

  def verify_submission(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/verify", params)
  end

  def submit(client, account_id, params) when is_map(params) do
    post(client, base_path(account_id) <> "/submit", params)
  end

  ## Read helpers

  def get_domain_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/domain-info", opts)
  end

  def list_recent_submissions(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/recent-submissions", opts)
  end

  def get_submission_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/submission-info", opts)
  end

  def list_tracked_domains(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/tracked-domains", opts)
  end

  def get_url_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/url-info", opts)
  end

  ## Global helpers

  def internal_submit(client, params \\ %{}) when is_map(params) do
    post(client, "/internal/submit", params)
  end

  def live(client) do
    c(client)
    |> Tesla.get("/live")
    |> handle_response()
  end

  def ready(client) do
    c(client)
    |> Tesla.get("/ready")
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/brand-protection"
  defp alerts_path(account_id), do: base_path(account_id) <> "/alerts"
  defp brands_path(account_id), do: base_path(account_id) <> "/brands"

  defp get(client, url, opts) do
    c(client)
    |> Tesla.get(with_query(url, opts))
    |> handle_response()
  end

  defp post(client, url, params) do
    c(client)
    |> Tesla.post(url, params)
    |> handle_response()
  end

  defp patch(client, url, params) do
    c(client)
    |> Tesla.patch(url, params)
    |> handle_response()
  end

  defp delete(client, url, params) do
    c(client)
    |> Tesla.delete(url, body: params)
    |> handle_response()
  end

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
