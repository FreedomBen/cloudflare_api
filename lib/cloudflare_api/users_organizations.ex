defmodule CloudflareApi.UsersOrganizations do
  @moduledoc ~S"""
  Manage user organizations via `/user/organizations`.
  """

  @doc ~S"""
  List users organizations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersOrganizations.list(client, [])
      {:ok, [%{"id" => "example"}]}

  """

  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("/user/organizations", opts))
    |> handle_response()
  end

  @doc ~S"""
  Get users organizations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersOrganizations.get(client, "organization_id", [])
      {:ok, %{"id" => "example"}}

  """

  def get(client, organization_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(org_path(organization_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete users organizations.

  Calls the Cloudflare API endpoint described in the moduledoc and
  returns `{:ok, result}` on success or `{:error, reason}` when the request fails.

  ## Examples

      iex> client = CloudflareApi.client("api-token")
      iex> CloudflareApi.UsersOrganizations.delete(client, "organization_id")
      {:ok, %{"id" => "example"}}

  """

  def delete(client, organization_id) do
    c(client)
    |> Tesla.delete(org_path(organization_id), body: %{})
    |> handle_response()
  end

  defp org_path(id), do: "/user/organizations/#{encode(id)}"
  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
