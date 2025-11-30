defmodule CloudflareApi.Organizations do
  @moduledoc ~S"""
  Organization management helpers (`/organizations`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List organizations accessible to the token (`GET /organizations`).
  """
  def list(client, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an organization (`POST /organizations`).
  """
  def create(client, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve an organization (`GET /organizations/:organization_id`).
  """
  def get(client, organization_id) do
    c(client)
    |> Tesla.get(org_path(organization_id))
    |> handle_response()
  end

  @doc ~S"""
  Replace organization metadata (`PUT /organizations/:organization_id`).
  """
  def update(client, organization_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(org_path(organization_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an organization (`DELETE /organizations/:organization_id`).
  """
  def delete(client, organization_id) do
    c(client)
    |> Tesla.delete(org_path(organization_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List accounts under an organization (`GET /organizations/:id/accounts`).
  """
  def list_accounts(client, organization_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(org_path(organization_id) <> "/accounts", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch the organization profile (`GET /organizations/:id/profile`).
  """
  def get_profile(client, organization_id) do
    c(client)
    |> Tesla.get(profile_path(organization_id))
    |> handle_response()
  end

  @doc ~S"""
  Update the organization profile (`PUT /organizations/:id/profile`).
  """
  def update_profile(client, organization_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(profile_path(organization_id), params)
    |> handle_response()
  end

  defp base_path, do: "/organizations"
  defp org_path(id), do: base_path() <> "/#{encode(id)}"
  defp profile_path(id), do: org_path(id) <> "/profile"

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
