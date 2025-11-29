defmodule CloudflareApi.PageShield do
  @moduledoc ~S"""
  Page Shield settings, connections, policies, and script metadata helpers
  (`/zones/:zone_id/page_shield`).
  """

  @doc ~S"""
  Fetch zone Page Shield settings (`GET /page_shield`).
  """
  def get_settings(client, zone_id) do
    c(client)
    |> Tesla.get(base_path(zone_id))
    |> handle_response()
  end

  @doc ~S"""
  Update Page Shield settings (`PUT /page_shield`).
  """
  def update_settings(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(base_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  List connections (`GET /page_shield/connections`).
  """
  def list_connections(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id) <> "/connections", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a specific connection (`GET /page_shield/connections/:connection_id`).
  """
  def get_connection(client, zone_id, connection_id) do
    c(client)
    |> Tesla.get(connection_path(zone_id, connection_id))
    |> handle_response()
  end

  @doc ~S"""
  List cookies (`GET /page_shield/cookies`).
  """
  def list_cookies(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id) <> "/cookies", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a cookie (`GET /page_shield/cookies/:cookie_id`).
  """
  def get_cookie(client, zone_id, cookie_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/cookies/" <> encode(cookie_id))
    |> handle_response()
  end

  @doc ~S"""
  List policies (`GET /page_shield/policies`).
  """
  def list_policies(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(policies_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Create a policy (`POST /page_shield/policies`).
  """
  def create_policy(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(policies_path(zone_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve a policy (`GET /page_shield/policies/:policy_id`).
  """
  def get_policy(client, zone_id, policy_id) do
    c(client)
    |> Tesla.get(policy_path(zone_id, policy_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a policy (`PUT /page_shield/policies/:policy_id`).
  """
  def update_policy(client, zone_id, policy_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(policy_path(zone_id, policy_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a policy (`DELETE /page_shield/policies/:policy_id`).
  """
  def delete_policy(client, zone_id, policy_id) do
    c(client)
    |> Tesla.delete(policy_path(zone_id, policy_id), body: %{})
    |> handle_response()
  end

  @doc ~S"""
  List detected scripts (`GET /page_shield/scripts`).
  """
  def list_scripts(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id) <> "/scripts", opts))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a detected script (`GET /page_shield/scripts/:script_id`).
  """
  def get_script(client, zone_id, script_id) do
    c(client)
    |> Tesla.get(base_path(zone_id) <> "/scripts/" <> encode(script_id))
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/page_shield"
  defp policies_path(zone_id), do: base_path(zone_id) <> "/policies"

  defp connection_path(zone_id, connection_id),
    do: base_path(zone_id) <> "/connections/" <> encode(connection_id)

  defp policy_path(zone_id, policy_id), do: policies_path(zone_id) <> "/#{encode(policy_id)}"

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
