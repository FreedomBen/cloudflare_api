defmodule CloudflareApi.OrganizationMembers do
  @moduledoc ~S"""
  Manage members of an organization (`/organizations/:organization_id/members`).
  """

  @doc ~S"""
  List organization members (`GET /organizations/:organization_id/members`).
  """
  def list(client, organization_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(organization_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Invite/create a member (`POST /organizations/:organization_id/members`).
  """
  def create(client, organization_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(organization_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Batch-create members (`POST /organizations/:organization_id/members:batchCreate`).
  """
  def batch_create(client, organization_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(organization_id) <> ":batchCreate", params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a member (`GET /organizations/:organization_id/members/:member_id`).
  """
  def get(client, organization_id, member_id) do
    c(client)
    |> Tesla.get(member_path(organization_id, member_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a member (`DELETE /organizations/:organization_id/members/:member_id`).
  """
  def delete(client, organization_id, member_id) do
    c(client)
    |> Tesla.delete(member_path(organization_id, member_id), body: %{})
    |> handle_response()
  end

  defp base_path(organization_id), do: "/organizations/#{encode(organization_id)}/members"
  defp member_path(org_id, member_id), do: base_path(org_id) <> "/#{encode(member_id)}"

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
