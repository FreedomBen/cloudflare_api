defmodule CloudflareApi.CloudflareImagesVariants do
  @moduledoc ~S"""
  Manage Cloudflare Images variants.
  """

  @doc ~S"""
  List cloudflare images variants.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareImagesVariants.list(client, "account_id")
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Create cloudflare images variants.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareImagesVariants.create(client, "account_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Get cloudflare images variants.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareImagesVariants.get(client, "account_id", "variant_id")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, variant_id) do
    c(client)
    |> Tesla.get(variant_path(account_id, variant_id))
    |> handle_response()
  end

  @doc ~S"""
  Update cloudflare images variants.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareImagesVariants.update(client, "account_id", "variant_id", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, variant_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(variant_path(account_id, variant_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete cloudflare images variants.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.CloudflareImagesVariants.delete(client, "account_id", "variant_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, account_id, variant_id) do
    c(client)
    |> Tesla.delete(variant_path(account_id, variant_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/images/v1/variants"
  defp variant_path(account_id, variant_id), do: base_path(account_id) <> "/#{variant_id}"

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
