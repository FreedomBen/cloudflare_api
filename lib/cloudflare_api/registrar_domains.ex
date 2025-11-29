defmodule CloudflareApi.RegistrarDomains do
  @moduledoc ~S"""
  Manage domains registered through Cloudflare Registrar (`/accounts/:account_id/registrar/domains`).
  """

  @doc ~S"""
  List registrar domains.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RegistrarDomains.list(client, "account_id", [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Get registrar domains.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RegistrarDomains.get(client, "account_id", "domain_name")
      {:ok, %{"id" => "example"}}

  """

  def get(client, account_id, domain_name) do
    c(client)
    |> Tesla.get(domain_path(account_id, domain_name))
    |> handle_response()
  end

  @doc ~S"""
  Update registrar domains.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.RegistrarDomains.update(client, "account_id", "domain_name", %{})
      {:ok, %{"id" => "example"}}

  """

  def update(client, account_id, domain_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(domain_path(account_id, domain_name), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/registrar/domains"

  defp domain_path(account_id, domain_name),
    do: base_path(account_id) <> "/#{encode(domain_name)}"

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
