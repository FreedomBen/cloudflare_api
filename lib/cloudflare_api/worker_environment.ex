defmodule CloudflareApi.WorkerEnvironment do
  @moduledoc ~S"""
  Manage Worker environments (script content + settings) under
  `/accounts/:account_id/workers/services/:service_name/environments/:environment_name`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Fetch the script content for an environment (`GET .../content`).
  """
  def get_content(client, account_id, service_name, environment_name) do
    c(client)
    |> Tesla.get(content_path(account_id, service_name, environment_name))
    |> handle_response()
  end

  @doc ~S"""
  Upload script content for an environment (`PUT .../content`).

  Pass a `Tesla.Multipart` struct or IO data representing the multipart payload.
  Provide optional `headers` to set `CF-WORKER-*` metadata (see API docs).
  """
  def put_content(client, account_id, service_name, environment_name, body, headers \\ []) do
    c(client)
    |> Tesla.put(
      content_path(account_id, service_name, environment_name),
      body,
      headers: headers
    )
    |> handle_response()
  end

  @doc ~S"""
  Fetch environment settings (`GET .../settings`).
  """
  def get_settings(client, account_id, service_name, environment_name) do
    c(client)
    |> Tesla.get(settings_path(account_id, service_name, environment_name))
    |> handle_response()
  end

  @doc ~S"""
  Patch environment settings (`PATCH .../settings`).
  """
  def patch_settings(client, account_id, service_name, environment_name, params)
      when is_map(params) do
    c(client)
    |> Tesla.patch(settings_path(account_id, service_name, environment_name), params)
    |> handle_response()
  end

  defp base_path(account_id, service_name, environment_name),
    do:
      "/accounts/#{account_id}/workers/services/#{encode(service_name)}/environments/#{encode(environment_name)}"

  defp content_path(account_id, service_name, environment_name),
    do: base_path(account_id, service_name, environment_name) <> "/content"

  defp settings_path(account_id, service_name, environment_name),
    do: base_path(account_id, service_name, environment_name) <> "/settings"

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
