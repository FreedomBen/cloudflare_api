defmodule CloudflareApi.TagCategory do
  @moduledoc ~S"""
  Manage Cloudforce One tag categories via `/accounts/:account_id/cloudforce-one/events/tags/categories`.
  """

  @doc ~S"""
  List tag categories (`GET /tags/categories`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a tag category (`POST /tags/categories/create`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/create", params)
    |> handle_response()
  end

  @doc ~S"""
  Update a tag category (`PATCH /tags/categories/:uuid`).
  """
  def update(client, account_id, category_uuid, params) when is_map(params) do
    c(client)
    |> Tesla.patch(category_path(account_id, category_uuid), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a tag category (`DELETE /tags/categories/:uuid`).
  """
  def delete(client, account_id, category_uuid) do
    c(client)
    |> Tesla.delete(category_path(account_id, category_uuid), body: %{})
    |> handle_response()
  end

  defp base(account_id),
    do: "/accounts/#{account_id}/cloudforce-one/events/tags/categories"

  defp category_path(account_id, category_uuid) do
    base(account_id) <> "/#{encode(category_uuid)}"
  end

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
