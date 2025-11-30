defmodule CloudflareApi.WorkerScript do
  @moduledoc ~S"""
  Covers the Worker Script APIs under `/accounts/:account_id/workers/scripts`.

  Exposes helpers for listing/searching scripts, uploading code (multipart),
  managing settings, secrets, subdomains, usage models, and asset uploads.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Upload static assets (`POST /accounts/:account_id/workers/assets/upload`).

  Pass a `Tesla.Multipart` (or IO data) for `body`. Required query parameters
  such as `:base64` should be supplied via `opts`.
  """
  def upload_assets(client, account_id, body, opts) when is_list(opts) do
    c(client)
    |> Tesla.post(with_query(assets_upload_path(account_id), opts), body)
    |> handle_response()
  end

  @doc ~S"""
  List the legacy scripts API (`GET /accounts/:account_id/workers/scripts`).
  """
  def list_scripts(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(scripts_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Search scripts (`GET /accounts/:account_id/workers/scripts-search`).
  """
  def search_scripts(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query("#{scripts_path(account_id)}-search", opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete a script (`DELETE /accounts/:account_id/workers/scripts/:script_name`).
  """
  def delete_script(client, account_id, script_name, opts \\ []) do
    c(client)
    |> Tesla.delete(with_query(script_path(account_id, script_name), opts), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Download a script (`GET /accounts/:account_id/workers/scripts/:script_name`).
  """
  def get_script(client, account_id, script_name) do
    c(client)
    |> Tesla.get(script_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Upload a worker module (`PUT /accounts/:account_id/workers/scripts/:script_name`).

  Accepts a `Tesla.Multipart` or IO data payload that matches the Workers
  multipart upload format.
  """
  def upload_module(client, account_id, script_name, body) do
    c(client)
    |> Tesla.put(script_path(account_id, script_name), body)
    |> handle_response()
  end

  @doc ~S"""
  Create an assets upload session (`POST .../assets-upload-session`).
  """
  def create_assets_upload_session(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(assets_session_path(account_id, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Upload script content (`PUT .../content`).

  Accepts multipart body plus optional headers for `CF-WORKER-BODY-PART` /
  `CF-WORKER-MAIN-MODULE-PART`.
  """
  def put_content(client, account_id, script_name, body, headers \\ []) do
    c(client)
    |> Tesla.put(content_path(account_id, script_name), body, headers: headers)
    |> handle_response()
  end

  @doc ~S"""
  Download script content (`GET .../content/v2`).
  """
  def get_content(client, account_id, script_name) do
    c(client)
    |> Tesla.get(content_v2_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Fetch script-level settings (`GET .../script-settings`).
  """
  def get_script_settings(client, account_id, script_name) do
    c(client)
    |> Tesla.get(script_settings_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Patch script-level settings (`PATCH .../script-settings`).
  """
  def patch_script_settings(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.patch(script_settings_path(account_id, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch current Worker settings (`GET .../settings`).
  """
  def get_settings(client, account_id, script_name) do
    c(client)
    |> Tesla.get(settings_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Patch Worker settings (`PATCH .../settings`).

  Pass a `Tesla.Multipart` (or IO data) body that encodes the `settings` payload.
  """
  def patch_settings(client, account_id, script_name, body) do
    c(client)
    |> Tesla.patch(settings_path(account_id, script_name), body)
    |> handle_response()
  end

  @doc ~S"""
  List secrets for a script (`GET .../secrets`).
  """
  def list_secrets(client, account_id, script_name) do
    c(client)
    |> Tesla.get(secrets_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Upsert a secret (`PUT .../secrets`).
  """
  def put_secret(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(secrets_path(account_id, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a secret binding (`DELETE .../secrets/:secret_name`).
  """
  def delete_secret(client, account_id, script_name, secret_name, opts \\ []) do
    c(client)
    |> Tesla.delete(with_query(secret_path(account_id, script_name, secret_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a secret binding (`GET .../secrets/:secret_name`).
  """
  def get_secret(client, account_id, script_name, secret_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(secret_path(account_id, script_name, secret_name), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete a Worker subdomain (`DELETE .../subdomain`).
  """
  def delete_subdomain(client, account_id, script_name) do
    c(client)
    |> Tesla.delete(subdomain_path(account_id, script_name), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch a Worker subdomain (`GET .../subdomain`).
  """
  def get_subdomain(client, account_id, script_name) do
    c(client)
    |> Tesla.get(subdomain_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Create or update a Worker subdomain (`POST .../subdomain`).
  """
  def create_subdomain(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.post(subdomain_path(account_id, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch the usage model (`GET .../usage-model`).
  """
  def get_usage_model(client, account_id, script_name) do
    c(client)
    |> Tesla.get(usage_model_path(account_id, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Update the usage model (`PUT .../usage-model`).
  """
  def update_usage_model(client, account_id, script_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(usage_model_path(account_id, script_name), params)
    |> handle_response()
  end

  defp scripts_path(account_id), do: "/accounts/#{account_id}/workers/scripts"
  defp assets_upload_path(account_id), do: "/accounts/#{account_id}/workers/assets/upload"

  defp assets_session_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/assets-upload-session"

  defp script_path(account_id, script_name),
    do: scripts_path(account_id) <> "/#{encode(script_name)}"

  defp content_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/content"

  defp content_v2_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/content/v2"

  defp script_settings_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/script-settings"

  defp settings_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/settings"

  defp secrets_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/secrets"

  defp secret_path(account_id, script_name, secret_name),
    do: secrets_path(account_id, script_name) <> "/#{encode(secret_name)}"

  defp subdomain_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/subdomain"

  defp usage_model_path(account_id, script_name),
    do: script_path(account_id, script_name) <> "/usage-model"

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
