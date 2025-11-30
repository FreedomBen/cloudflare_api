defmodule CloudflareApi.DlpProfiles do
  @moduledoc ~S"""
  Manage DLP profiles under `/accounts/:account_id/dlp/profiles`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    query = if opts == [], do: "", else: "?" <> CloudflareApi.uri_encode_opts(opts)
    request(client, :get, base_path(account_id) <> query)
  end

  @doc ~S"""
  List custom for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.list_custom(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list_custom(client, account_id) do
    request(client, :get, custom_path(account_id))
  end

  @doc ~S"""
  Create custom for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.create_custom(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_custom(client, account_id, params) when is_map(params) do
    request(client, :post, custom_path(account_id), params)
  end

  @doc ~S"""
  Get custom for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.get_custom(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def get_custom(client, account_id, profile_id) do
    request(client, :get, custom_path(account_id) <> "/#{profile_id}")
  end

  @doc ~S"""
  Update custom for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.update_custom(client, "account_id", "profile_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_custom(client, account_id, profile_id, params) when is_map(params) do
    request(client, :put, custom_path(account_id) <> "/#{profile_id}", params)
  end

  @doc ~S"""
  Delete custom for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.delete_custom(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_custom(client, account_id, profile_id) do
    request(client, :delete, custom_path(account_id) <> "/#{profile_id}", %{})
  end

  @doc ~S"""
  Create predefined for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.create_predefined(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_predefined(client, account_id, params) when is_map(params) do
    request(client, :post, predefined_path(account_id), params)
  end

  @doc ~S"""
  Get predefined for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.get_predefined(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def get_predefined(client, account_id, profile_id) do
    request(client, :get, predefined_path(account_id) <> "/#{profile_id}")
  end

  @doc ~S"""
  Update predefined for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.update_predefined(client, "account_id", "profile_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_predefined(client, account_id, profile_id, params) when is_map(params) do
    request(client, :put, predefined_path(account_id) <> "/#{profile_id}", params)
  end

  @doc ~S"""
  Delete predefined for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.delete_predefined(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def delete_predefined(client, account_id, profile_id) do
    request(client, :delete, predefined_path(account_id) <> "/#{profile_id}", %{})
  end

  @doc ~S"""
  Predefined config for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.predefined_config(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def predefined_config(client, account_id, profile_id) do
    request(client, :get, predefined_path(account_id) <> "/#{profile_id}/config")
  end

  @doc ~S"""
  Create predefined config for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.create_predefined_config(client, "account_id", "profile_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_predefined_config(client, account_id, profile_id, params) when is_map(params) do
    request(client, :post, predefined_path(account_id) <> "/#{profile_id}/config", params)
  end

  @doc ~S"""
  Update predefined config for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.update_predefined_config(client, "account_id", "profile_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update_predefined_config(client, account_id, profile_id, params) when is_map(params) do
    request(client, :put, predefined_path(account_id) <> "/#{profile_id}/config", params)
  end

  @doc ~S"""
  Get profile for dlp profiles.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.DlpProfiles.get_profile(client, "account_id", "profile_id")
      {:ok, %{"id" => "example"}}

  """

  def get_profile(client, account_id, profile_id) do
    request(client, :get, base_path(account_id) <> "/#{profile_id}")
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/dlp/profiles"
  defp custom_path(account_id), do: base_path(account_id) <> "/custom"
  defp predefined_path(account_id), do: base_path(account_id) <> "/predefined"

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} -> Tesla.get(client, url)
        {:delete, %{} = params} -> Tesla.delete(client, url, body: params)
        {:post, %{} = params} -> Tesla.post(client, url, params)
        {:put, %{} = params} -> Tesla.put(client, url, params)
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
