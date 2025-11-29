defmodule CloudflareApi.BrandProtection do
  @moduledoc ~S"""
  Brand Protection API helpers under `/accounts/:account_id/brand-protection`.
  """

  ## Alerts

  @doc ~S"""
  List alerts for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.list_alerts(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_alerts(client, account_id, opts \\ []) do
    get(client, alerts_path(account_id), opts)
  end

  @doc ~S"""
  Update alerts for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.update_alerts(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_alerts(client, account_id, params) when is_map(params) do
    patch(client, alerts_path(account_id), params)
  end

  @doc ~S"""
  Clear alerts for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.clear_alerts(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def clear_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/clear", params)
  end

  @doc ~S"""
  Refute alerts for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.refute_alerts(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def refute_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/refute", params)
  end

  @doc ~S"""
  Verify alerts for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.verify_alerts(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def verify_alerts(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, alerts_path(account_id) <> "/verify", params)
  end

  ## Brands & Patterns

  @doc ~S"""
  List brands for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.list_brands(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_brands(client, account_id, opts \\ []) do
    get(client, brands_path(account_id), opts)
  end

  @doc ~S"""
  Create brand for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.create_brand(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_brand(client, account_id, params) when is_map(params) do
    post(client, brands_path(account_id), params)
  end

  @doc ~S"""
  Delete brands for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.delete_brands(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_brands(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, brands_path(account_id), params)
  end

  @doc ~S"""
  List brand patterns for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.list_brand_patterns(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_brand_patterns(client, account_id, opts \\ []) do
    get(client, brands_path(account_id) <> "/patterns", opts)
  end

  @doc ~S"""
  Create brand pattern for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.create_brand_pattern(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_brand_pattern(client, account_id, params) when is_map(params) do
    post(client, brands_path(account_id) <> "/patterns", params)
  end

  @doc ~S"""
  Delete brand patterns for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.delete_brand_patterns(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def delete_brand_patterns(client, account_id, params \\ %{}) when is_map(params) do
    delete(client, brands_path(account_id) <> "/patterns", params)
  end

  ## Submission helpers

  @doc ~S"""
  Clear submissions for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.clear_submissions(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def clear_submissions(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/clear", params)
  end

  @doc ~S"""
  Refute submission for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.refute_submission(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def refute_submission(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/refute", params)
  end

  @doc ~S"""
  Verify submission for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.verify_submission(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def verify_submission(client, account_id, params \\ %{}) when is_map(params) do
    patch(client, base_path(account_id) <> "/verify", params)
  end

  @doc ~S"""
  Submit brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.submit(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def submit(client, account_id, params) when is_map(params) do
    post(client, base_path(account_id) <> "/submit", params)
  end

  ## Read helpers

  @doc ~S"""
  Get domain info for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.get_domain_info(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_domain_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/domain-info", opts)
  end

  @doc ~S"""
  List recent submissions for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.list_recent_submissions(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_recent_submissions(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/recent-submissions", opts)
  end

  @doc ~S"""
  Get submission info for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.get_submission_info(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_submission_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/submission-info", opts)
  end

  @doc ~S"""
  List tracked domains for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.list_tracked_domains(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list_tracked_domains(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/tracked-domains", opts)
  end

  @doc ~S"""
  Get url info for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.get_url_info(client, "account_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get_url_info(client, account_id, opts \\ []) do
    get(client, base_path(account_id) <> "/url-info", opts)
  end

  ## Global helpers

  @doc ~S"""
  Internal submit for brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.internal_submit(client, %{})
      {:ok, %{"id" => "example"}}

  """

  def internal_submit(client, params \\ %{}) when is_map(params) do
    post(client, "/internal/submit", params)
  end

  @doc ~S"""
  Live brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.live(client)
      {:ok, %{"id" => "example"}}

  """

  def live(client) do
    c(client)
    |> Tesla.get("/live")
    |> handle_response()
  end

  @doc ~S"""
  Ready brand protection.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.BrandProtection.ready(client)
      {:ok, %{"id" => "example"}}

  """

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
