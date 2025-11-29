defmodule CloudflareApi.Triggers do
  @moduledoc ~S"""
  Manage build triggers under `/accounts/:account_id/builds/triggers`.
  """

  @doc ~S"""
  Create triggers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Triggers.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Update triggers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Triggers.update(client, "account_id", "trigger_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, trigger_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(trigger_path(account_id, trigger_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete triggers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Triggers.delete(client, "account_id", "trigger_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, trigger_id) do
    c(client)
    |> Tesla.delete(trigger_path(account_id, trigger_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Create manual build for triggers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Triggers.create_manual_build(client, "account_id", "trigger_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create_manual_build(client, account_id, trigger_id, params \\ %{}) do
    c(client)
    |> Tesla.post(trigger_path(account_id, trigger_id) <> "/builds", params)
    |> handle_response()
  end

  @doc ~S"""
  Purge build cache for triggers.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.Triggers.purge_build_cache(client, "account_id", "trigger_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def purge_build_cache(client, account_id, trigger_id, params \\ %{}) do
    c(client)
    |> Tesla.post(trigger_path(account_id, trigger_id) <> "/purge_build_cache", params)
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/builds/triggers"

  defp trigger_path(account_id, trigger_id) do
    base(account_id) <> "/#{encode(trigger_id)}"
  end

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
