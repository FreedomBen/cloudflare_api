defmodule CloudflareApi.Tag do
  @moduledoc ~S"""
  Manage Cloudforce One tags under `/accounts/:account_id/cloudforce-one/events/tags`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List tags (`GET /events/tags`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a tag (`POST /events/tags/create`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id) <> "/create", params)
    |> handle_response()
  end

  @doc ~S"""
  Update a tag (`PATCH /events/tags/:tag_uuid`).
  """
  def update(client, account_id, tag_uuid, params) when is_map(params) do
    c(client)
    |> Tesla.patch(tag_path(account_id, tag_uuid), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a tag (`DELETE /events/tags/:tag_uuid`).
  """
  def delete(client, account_id, tag_uuid) do
    c(client)
    |> Tesla.delete(tag_path(account_id, tag_uuid), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List indicators for a tag/dataset (`GET /events/dataset/:dataset_id/tags/:tag_uuid/indicators`).
  """
  def list_indicators(client, account_id, dataset_id, tag_uuid, opts \\ []) do
    c(client)
    |> Tesla.get(
      with_query(
        "/accounts/#{account_id}/cloudforce-one/events/dataset/#{encode(dataset_id)}/tags/#{encode(tag_uuid)}/indicators",
        opts
      )
    )
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/cloudforce-one/events/tags"

  defp tag_path(account_id, tag_uuid) do
    base(account_id) <> "/#{encode(tag_uuid)}"
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
