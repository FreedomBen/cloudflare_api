defmodule CloudflareApi.ZeroTrustLists do
  @moduledoc ~S"""
  Manage Zero Trust lists (`/accounts/:account_id/gateway/lists`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List lists (`GET /accounts/:account_id/gateway/lists`), with optional `:type` filter.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Create a list (`POST /accounts/:account_id/gateway/lists`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a list (`DELETE .../lists/:list_id`).
  """
  def delete(client, account_id, list_id, params \\ %{}) do
    c(client)
    |> Tesla.delete(list_path(account_id, list_id), body: params)
    |> handle_response()
  end

  @doc """
  Fetch list details (`GET .../lists/:list_id`).
  """
  def get(client, account_id, list_id) do
    c(client)
    |> Tesla.get(list_path(account_id, list_id))
    |> handle_response()
  end

  @doc """
  Patch a list (`PATCH .../lists/:list_id`).
  """
  def patch(client, account_id, list_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(list_path(account_id, list_id), params)
    |> handle_response()
  end

  @doc """
  Replace a list (`PUT .../lists/:list_id`).
  """
  def update(client, account_id, list_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(list_path(account_id, list_id), params)
    |> handle_response()
  end

  @doc """
  List items in a list (`GET .../lists/:list_id/items`).
  """
  def list_items(client, account_id, list_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(list_items_path(account_id, list_id), opts))
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/gateway/lists"

  defp list_path(account_id, list_id),
    do: base_path(account_id) <> "/#{encode(list_id)}"

  defp list_items_path(account_id, list_id),
    do: list_path(account_id, list_id) <> "/items"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
