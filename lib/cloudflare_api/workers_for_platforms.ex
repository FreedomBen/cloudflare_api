defmodule CloudflareApi.WorkersForPlatforms do
  @moduledoc ~S"""
  Helpers for Workers for Platforms (`/workers/dispatch/namespaces`).
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List dispatch namespaces (`GET /accounts/:account_id/workers/dispatch/namespaces`).
  """
  def list_namespaces(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a dispatch namespace (`POST /accounts/:account_id/workers/dispatch/namespaces`).
  """
  def create_namespace(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a namespace (`DELETE .../namespaces/:dispatch_namespace`).
  """
  def delete_namespace(client, account_id, namespace) do
    c(client)
    |> Tesla.delete(namespace_path(account_id, namespace), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch namespace details (`GET .../namespaces/:dispatch_namespace`).
  """
  def get_namespace(client, account_id, namespace) do
    c(client)
    |> Tesla.get(namespace_path(account_id, namespace))
    |> handle_response()
  end

  @doc ~S"""
  Patch namespace metadata (`PATCH .../namespaces/:dispatch_namespace`).
  """
  def patch_namespace(client, account_id, namespace, params) when is_map(params) do
    c(client)
    |> Tesla.patch(namespace_path(account_id, namespace), params)
    |> handle_response()
  end

  @doc ~S"""
  Replace namespace metadata (`PUT .../namespaces/:dispatch_namespace`).
  """
  def update_namespace(client, account_id, namespace, params) when is_map(params) do
    c(client)
    |> Tesla.put(namespace_path(account_id, namespace), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete scripts within a namespace (`DELETE .../scripts`).

  Supports `:tags` and `:limit` query filters.
  """
  def delete_scripts(client, account_id, namespace, opts \\ []) do
    c(client)
    |> Tesla.delete(with_query(scripts_path(account_id, namespace), opts), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List scripts within a namespace (`GET .../scripts`).
  """
  def list_scripts(client, account_id, namespace, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(scripts_path(account_id, namespace), opts))
    |> handle_response()
  end

  @doc ~S"""
  Delete a single script (`DELETE .../scripts/:script_name`).
  """
  def delete_script(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.delete(script_path(account_id, namespace, script_name), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Fetch script details (`GET .../scripts/:script_name`).
  """
  def get_script(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Upload a Worker module (`PUT .../scripts/:script_name`).

  Accepts a `Tesla.Multipart` or IO data payload.
  """
  def upload_script_module(client, account_id, namespace, script_name, body) do
    c(client)
    |> Tesla.put(script_path(account_id, namespace, script_name), body)
    |> handle_response()
  end

  @doc ~S"""
  Create an assets upload session (`POST .../scripts/:script_name/assets-upload-session`).
  """
  def create_assets_upload_session(client, account_id, namespace, script_name, params)
      when is_map(params) do
    c(client)
    |> Tesla.post(assets_session_path(account_id, namespace, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve script bindings (`GET .../scripts/:script_name/bindings`).
  """
  def get_script_bindings(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_bindings_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Fetch script content (`GET .../scripts/:script_name/content`).
  """
  def get_script_content(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_content_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Upload script content (`PUT .../scripts/:script_name/content`).

  Accepts multipart/IO data plus optional headers.
  """
  def put_script_content(client, account_id, namespace, script_name, body, headers \\ []) do
    c(client)
    |> Tesla.put(script_content_path(account_id, namespace, script_name), body, headers: headers)
    |> handle_response()
  end

  @doc ~S"""
  List script secrets (`GET .../scripts/:script_name/secrets`).
  """
  def list_script_secrets(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_secrets_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Upsert secrets (`PUT .../scripts/:script_name/secrets`).
  """
  def put_script_secrets(client, account_id, namespace, script_name, params)
      when is_map(params) do
    c(client)
    |> Tesla.put(script_secrets_path(account_id, namespace, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a script secret (`DELETE .../secrets/:secret_name`).
  """
  def delete_script_secret(client, account_id, namespace, script_name, secret_name) do
    c(client)
    |> Tesla.delete(script_secret_path(account_id, namespace, script_name, secret_name),
      body: %{}
    )
    |> handle_response()
  end

  @doc ~S"""
  Fetch a script secret (`GET .../secrets/:secret_name`).
  """
  def get_script_secret(client, account_id, namespace, script_name, secret_name) do
    c(client)
    |> Tesla.get(script_secret_path(account_id, namespace, script_name, secret_name))
    |> handle_response()
  end

  @doc ~S"""
  Fetch script settings (`GET .../scripts/:script_name/settings`).
  """
  def get_script_settings(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_settings_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Patch script settings (`PATCH .../scripts/:script_name/settings`).
  """
  def patch_script_settings(client, account_id, namespace, script_name, params)
      when is_map(params) do
    c(client)
    |> Tesla.patch(script_settings_path(account_id, namespace, script_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Fetch script tags (`GET .../scripts/:script_name/tags`).
  """
  def get_script_tags(client, account_id, namespace, script_name) do
    c(client)
    |> Tesla.get(script_tags_path(account_id, namespace, script_name))
    |> handle_response()
  end

  @doc ~S"""
  Replace all tags (`PUT .../scripts/:script_name/tags`).
  """
  def put_script_tags(client, account_id, namespace, script_name, tags) do
    c(client)
    |> Tesla.put(script_tags_path(account_id, namespace, script_name), tags)
    |> handle_response()
  end

  @doc ~S"""
  Delete a single tag (`DELETE .../tags/:tag`).
  """
  def delete_script_tag(client, account_id, namespace, script_name, tag) do
    c(client)
    |> Tesla.delete(script_tag_path(account_id, namespace, script_name, tag), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  Upsert a single tag (`PUT .../tags/:tag`).
  """
  def put_script_tag(client, account_id, namespace, script_name, tag, params \\ %{}) do
    c(client)
    |> Tesla.put(script_tag_path(account_id, namespace, script_name, tag), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/workers/dispatch/namespaces"

  defp namespace_path(account_id, namespace),
    do: base_path(account_id) <> "/#{encode(namespace)}"

  defp scripts_path(account_id, namespace),
    do: namespace_path(account_id, namespace) <> "/scripts"

  defp script_path(account_id, namespace, script_name),
    do: scripts_path(account_id, namespace) <> "/#{encode(script_name)}"

  defp assets_session_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/assets-upload-session"

  defp script_bindings_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/bindings"

  defp script_content_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/content"

  defp script_secrets_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/secrets"

  defp script_secret_path(account_id, namespace, script_name, secret_name),
    do: script_secrets_path(account_id, namespace, script_name) <> "/#{encode(secret_name)}"

  defp script_settings_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/settings"

  defp script_tags_path(account_id, namespace, script_name),
    do: script_path(account_id, namespace, script_name) <> "/tags"

  defp script_tag_path(account_id, namespace, script_name, tag),
    do: script_tags_path(account_id, namespace, script_name) <> "/#{encode(tag)}"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
