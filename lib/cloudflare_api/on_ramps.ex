defmodule CloudflareApi.OnRamps do
  @moduledoc ~S"""
  Manage Magic WAN On-ramps (`/accounts/:account_id/magic/cloud/onramps`).
  """

  @doc ~S"""
  List on-ramps for an account (`GET /magic/cloud/onramps`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create an on-ramp (`POST /magic/cloud/onramps`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch details for an on-ramp (`GET /magic/cloud/onramps/:onramp_id`).
  """
  def get(client, account_id, onramp_id) do
    c(client)
    |> Tesla.get(onramp_path(account_id, onramp_id))
    |> handle_response()
  end

  @doc ~S"""
  Replace an on-ramp definition (`PUT /magic/cloud/onramps/:onramp_id`).
  """
  def update(client, account_id, onramp_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(onramp_path(account_id, onramp_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Partially update an on-ramp (`PATCH /magic/cloud/onramps/:onramp_id`).
  """
  def patch(client, account_id, onramp_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(onramp_path(account_id, onramp_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete an on-ramp (`DELETE /magic/cloud/onramps/:onramp_id`).
  """
  def delete(client, account_id, onramp_id) do
    c(client)
    |> Tesla.delete(onramp_path(account_id, onramp_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Apply a planned configuration (`POST .../:onramp_id/apply`).
  """
  def apply_changes(client, account_id, onramp_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(onramp_path(account_id, onramp_id) <> "/apply", params)
    |> handle_response()
  end

  @doc ~S"""
  Generate a configuration plan (`POST .../:onramp_id/plan`).
  """
  def plan(client, account_id, onramp_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(onramp_path(account_id, onramp_id) <> "/plan", params)
    |> handle_response()
  end

  @doc ~S"""
  Export the configuration (`POST .../:onramp_id/export`).
  """
  def export(client, account_id, onramp_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(onramp_path(account_id, onramp_id) <> "/export", params)
    |> handle_response()
  end

  @doc ~S"""
  Read the Magic WAN address space (`GET .../magic_wan_address_space`).
  """
  def get_magic_wan_address_space(client, account_id) do
    c(client)
    |> Tesla.get(address_space_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Replace the Magic WAN address space (`PUT .../magic_wan_address_space`).
  """
  def update_magic_wan_address_space(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(address_space_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Patch the Magic WAN address space (`PATCH .../magic_wan_address_space`).
  """
  def patch_magic_wan_address_space(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(address_space_path(account_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/magic/cloud/onramps"

  defp onramp_path(account_id, onramp_id),
    do: base_path(account_id) <> "/" <> encode(onramp_id)

  defp address_space_path(account_id),
    do: base_path(account_id) <> "/magic_wan_address_space"

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
