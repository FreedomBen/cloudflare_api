defmodule CloudflareApi.Brapi do
  @moduledoc ~S"""
  Browser Rendering API (BRAPI) helpers under `/accounts/:account_id/browser-rendering`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Render content for brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.render_content(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def render_content(client, account_id, params) when is_map(params),
    do: post(client, account_id, "content", params)

  @doc ~S"""
  Render json for brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.render_json(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def render_json(client, account_id, params) when is_map(params),
    do: post(client, account_id, "json", params)

  @doc ~S"""
  Render links for brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.render_links(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def render_links(client, account_id, params) when is_map(params),
    do: post(client, account_id, "links", params)

  @doc ~S"""
  Render markdown for brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.render_markdown(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def render_markdown(client, account_id, params) when is_map(params),
    do: post(client, account_id, "markdown", params)

  @doc ~S"""
  Render pdf for brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.render_pdf(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def render_pdf(client, account_id, params) when is_map(params),
    do: post(client, account_id, "pdf", params)

  @doc ~S"""
  Scrape brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.scrape(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def scrape(client, account_id, params) when is_map(params),
    do: post(client, account_id, "scrape", params)

  @doc ~S"""
  Screenshot brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.screenshot(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def screenshot(client, account_id, params) when is_map(params),
    do: post(client, account_id, "screenshot", params)

  @doc ~S"""
  Snapshot brapi.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Brapi.snapshot(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def snapshot(client, account_id, params) when is_map(params),
    do: post(client, account_id, "snapshot", params)

  defp post(client, account_id, suffix, params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/#{suffix}", params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/browser-rendering"

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
