defmodule CloudflareApi.ZeroTrustHostnameRoute do
  @moduledoc ~S"""
  Manage Zero Trust hostname routes (`/accounts/:account_id/zerotrust/routes/hostname`).
  """

  use CloudflareApi.Typespecs

  @doc """
  List hostname routes (`GET /accounts/:account_id/zerotrust/routes/hostname`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Create a hostname route (`POST /accounts/:account_id/zerotrust/routes/hostname`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc """
  Delete a hostname route (`DELETE .../hostname/:hostname_route_id`).
  """
  def delete(client, account_id, route_id) do
    c(client)
    |> Tesla.delete(route_path(account_id, route_id), body: %{})
    |> handle_response()
  end

  @doc """
  Get hostname route (`GET .../hostname/:hostname_route_id`).
  """
  def get(client, account_id, route_id) do
    c(client)
    |> Tesla.get(route_path(account_id, route_id))
    |> handle_response()
  end

  @doc """
  Patch hostname route (`PATCH .../hostname/:hostname_route_id`).
  """
  def update(client, account_id, route_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(route_path(account_id, route_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/zerotrust/routes/hostname"

  defp route_path(account_id, route_id),
    do: base_path(account_id) <> "/#{encode(route_id)}"

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
