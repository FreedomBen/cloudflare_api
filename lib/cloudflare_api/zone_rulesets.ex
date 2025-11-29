defmodule CloudflareApi.ZoneRulesets do
  @moduledoc ~S"""
  Manage zone-level rulesets, versions, entrypoints, and rules under
  `/zones/:zone_id/rulesets`.
  """

  ## Rulesets

  def list(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(zone_id), opts))
    |> handle_response()
  end

  def create(client, zone_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(zone_id), params)
    |> handle_response()
  end

  def get(client, zone_id, ruleset_id) do
    c(client)
    |> Tesla.get(ruleset_path(zone_id, ruleset_id))
    |> handle_response()
  end

  def update(client, zone_id, ruleset_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(ruleset_path(zone_id, ruleset_id), params)
    |> handle_response()
  end

  def delete(client, zone_id, ruleset_id) do
    c(client)
    |> Tesla.delete(ruleset_path(zone_id, ruleset_id), body: %{})
    |> handle_response()
  end

  ## Rules

  def create_rule(client, zone_id, ruleset_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(rules_path(zone_id, ruleset_id), params)
    |> handle_response()
  end

  def update_rule(client, zone_id, ruleset_id, rule_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(rule_path(zone_id, ruleset_id, rule_id), params)
    |> handle_response()
  end

  def delete_rule(client, zone_id, ruleset_id, rule_id) do
    c(client)
    |> Tesla.delete(rule_path(zone_id, ruleset_id, rule_id), body: %{})
    |> handle_response()
  end

  ## Versions

  def list_versions(client, zone_id, ruleset_id) do
    c(client)
    |> Tesla.get(versions_path(zone_id, ruleset_id))
    |> handle_response()
  end

  def get_version(client, zone_id, ruleset_id, version_id) do
    c(client)
    |> Tesla.get(version_path(zone_id, ruleset_id, version_id))
    |> handle_response()
  end

  def delete_version(client, zone_id, ruleset_id, version_id) do
    c(client)
    |> Tesla.delete(version_path(zone_id, ruleset_id, version_id), body: %{})
    |> handle_response()
  end

  def list_version_rules_by_tag(client, zone_id, ruleset_id, version_id, rule_tag) do
    c(client)
    |> Tesla.get(version_tag_path(zone_id, ruleset_id, version_id, rule_tag))
    |> handle_response()
  end

  ## Entrypoints

  def get_entrypoint(client, zone_id, phase) do
    c(client)
    |> Tesla.get(entrypoint_path(zone_id, phase))
    |> handle_response()
  end

  def update_entrypoint(client, zone_id, phase, params) when is_map(params) do
    c(client)
    |> Tesla.put(entrypoint_path(zone_id, phase), params)
    |> handle_response()
  end

  def list_entrypoint_versions(client, zone_id, phase) do
    c(client)
    |> Tesla.get(entrypoint_versions_path(zone_id, phase))
    |> handle_response()
  end

  def get_entrypoint_version(client, zone_id, phase, version_id) do
    c(client)
    |> Tesla.get(entrypoint_version_path(zone_id, phase, version_id))
    |> handle_response()
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/rulesets"
  defp ruleset_path(zone_id, ruleset_id), do: base_path(zone_id) <> "/#{ruleset_id}"
  defp rules_path(zone_id, ruleset_id), do: ruleset_path(zone_id, ruleset_id) <> "/rules"

  defp rule_path(zone_id, ruleset_id, rule_id),
    do: rules_path(zone_id, ruleset_id) <> "/#{rule_id}"

  defp versions_path(zone_id, ruleset_id), do: ruleset_path(zone_id, ruleset_id) <> "/versions"

  defp version_path(zone_id, ruleset_id, version_id),
    do: versions_path(zone_id, ruleset_id) <> "/#{version_id}"

  defp version_tag_path(zone_id, ruleset_id, version_id, rule_tag),
    do: version_path(zone_id, ruleset_id, version_id) <> "/by_tag/#{rule_tag}"

  defp entrypoint_base(zone_id, phase),
    do: "/zones/#{zone_id}/rulesets/phases/#{phase}/entrypoint"

  defp entrypoint_path(zone_id, phase), do: entrypoint_base(zone_id, phase)

  defp entrypoint_versions_path(zone_id, phase),
    do: entrypoint_base(zone_id, phase) <> "/versions"

  defp entrypoint_version_path(zone_id, phase, version_id),
    do: entrypoint_versions_path(zone_id, phase) <> "/#{version_id}"

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
