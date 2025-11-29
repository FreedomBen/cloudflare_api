defmodule CloudflareApi.Category do
  @moduledoc ~S"""
  Manage Cloudforce One event categories.
  """

  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(categories_url(account_id, opts))
    |> handle_response()
  end

  def catalog(client, account_id) do
    c(client)
    |> Tesla.get("/accounts/#{account_id}/cloudforce-one/events/categories/catalog")
    |> handle_response()
  end

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/create", params)
    |> handle_response()
  end

  def get(client, account_id, category_id) do
    c(client)
    |> Tesla.get(category_path(account_id, category_id))
    |> handle_response()
  end

  def update_patch(client, account_id, category_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(category_path(account_id, category_id), params)
    |> handle_response()
  end

  def update_post(client, account_id, category_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(category_path(account_id, category_id), params)
    |> handle_response()
  end

  def delete(client, account_id, category_id) do
    c(client)
    |> Tesla.delete(category_path(account_id, category_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/cloudforce-one/events/categories"

  defp categories_url(account_id, []), do: base_path(account_id)

  defp categories_url(account_id, opts),
    do: base_path(account_id) <> "?" <> encode_list_opts(opts)

  defp category_path(account_id, category_id), do: base_path(account_id) <> "/#{category_id}"

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp encode_list_opts(opts) do
    opts
    |> Enum.flat_map(fn
      {key, value} when is_list(value) -> Enum.map(value, &{key, &1})
      pair -> [pair]
    end)
    |> URI.encode_query()
  end

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
