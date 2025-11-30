defmodule CloudflareApi.PhysicalDevices do
  @moduledoc ~S"""
  Manage physical device registrations via `/accounts/:account_id/devices` endpoints.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List physical devices (`GET /devices/physical-devices`).
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a physical device (`GET /devices/physical-devices/:device_id`).
  """
  def get(client, account_id, device_id) do
    c(client)
    |> Tesla.get(device_path(account_id, device_id))
    |> handle_response()
  end

  @doc ~S"""
  Delete a physical device (`DELETE /devices/physical-devices/:device_id`).
  """
  def delete(client, account_id, device_id) do
    c(client)
    |> Tesla.delete(device_path(account_id, device_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Revoke a device (`POST /devices/physical-devices/:device_id/revoke`).
  """
  def revoke(client, account_id, device_id, params \\ %{}) when is_map(params) do
    c(client)
    |> Tesla.post(device_path(account_id, device_id) <> "/revoke", params)
    |> handle_response()
  end

  @doc ~S"""
  Delete registrations (`DELETE /devices/registrations`).
  """
  def delete_registrations(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.delete(registrations_path(account_id), body: params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/devices/physical-devices"
  defp device_path(account_id, device_id), do: base_path(account_id) <> "/#{encode(device_id)}"
  defp registrations_path(account_id), do: "/accounts/#{account_id}/devices/registrations"

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
