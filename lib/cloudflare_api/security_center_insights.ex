defmodule CloudflareApi.SecurityCenterInsights do
  @moduledoc ~S"""
  Wrap Security Center insight and legacy attack-surface-report endpoints for accounts and zones.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List legacy attack surface issue types (`GET /intel/attack-surface-report/issue-types`).
  """
  def list_issue_types(client, account_id) do
    c(client)
    |> Tesla.get(attack_surface_path(account_id) <> "/issue-types")
    |> handle_response()
  end

  @doc ~S"""
  List legacy attack surface issues (`GET /intel/attack-surface-report/issues`).
  """
  def list_attack_surface_issues(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(attack_surface_path(account_id) <> "/issues", opts))
    |> handle_response()
  end

  @doc ~S"""
  Count attack surface issues grouped by class (`GET /issues/class`).
  """
  def attack_surface_counts_by_class(client, account_id, opts \\ []) do
    grouped_counts(client, attack_surface_path(account_id) <> "/issues/class", opts)
  end

  @doc ~S"""
  Count attack surface issues grouped by severity (`GET /issues/severity`).
  """
  def attack_surface_counts_by_severity(client, account_id, opts \\ []) do
    grouped_counts(client, attack_surface_path(account_id) <> "/issues/severity", opts)
  end

  @doc ~S"""
  Count attack surface issues grouped by type (`GET /issues/type`).
  """
  def attack_surface_counts_by_type(client, account_id, opts \\ []) do
    grouped_counts(client, attack_surface_path(account_id) <> "/issues/type", opts)
  end

  @doc ~S"""
  Dismiss/restore a legacy attack surface issue (`PUT /intel/attack-surface-report/:issue_id/dismiss`).
  """
  def dismiss_attack_surface_issue(client, account_id, issue_id, params \\ %{"dismiss" => true})
      when is_map(params) do
    c(client)
    |> Tesla.put(attack_surface_path(account_id) <> "/#{encode(issue_id)}/dismiss", params)
    |> handle_response()
  end

  @doc ~S"""
  List Security Center insights for an account (`GET /security-center/insights`).
  """
  def list_insights(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(insights_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Count insights grouped by class (`GET /security-center/insights/class`).
  """
  def insight_counts_by_class(client, account_id, opts \\ []) do
    grouped_counts(client, insights_path(account_id) <> "/class", opts)
  end

  @doc ~S"""
  Count insights grouped by severity (`GET /security-center/insights/severity`).
  """
  def insight_counts_by_severity(client, account_id, opts \\ []) do
    grouped_counts(client, insights_path(account_id) <> "/severity", opts)
  end

  @doc ~S"""
  Count insights grouped by type (`GET /security-center/insights/type`).
  """
  def insight_counts_by_type(client, account_id, opts \\ []) do
    grouped_counts(client, insights_path(account_id) <> "/type", opts)
  end

  @doc ~S"""
  Dismiss/restore an account insight (`PUT /security-center/insights/:issue_id/dismiss`).
  """
  def dismiss_insight(client, account_id, issue_id, params \\ %{"dismiss" => true})
      when is_map(params) do
    c(client)
    |> Tesla.put(insights_path(account_id) <> "/#{encode(issue_id)}/dismiss", params)
    |> handle_response()
  end

  @doc ~S"""
  List Security Center insights for a zone (`GET /zones/:zone_id/security-center/insights`).
  """
  def list_zone_insights(client, zone_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(zone_insights_path(zone_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Zone insight counts by class (`GET /zones/:zone_id/security-center/insights/class`).
  """
  def zone_insight_counts_by_class(client, zone_id, opts \\ []) do
    grouped_counts(client, zone_insights_path(zone_id) <> "/class", opts)
  end

  @doc ~S"""
  Zone insight counts by severity (`GET /zones/:zone_id/security-center/insights/severity`).
  """
  def zone_insight_counts_by_severity(client, zone_id, opts \\ []) do
    grouped_counts(client, zone_insights_path(zone_id) <> "/severity", opts)
  end

  @doc ~S"""
  Zone insight counts by type (`GET /zones/:zone_id/security-center/insights/type`).
  """
  def zone_insight_counts_by_type(client, zone_id, opts \\ []) do
    grouped_counts(client, zone_insights_path(zone_id) <> "/type", opts)
  end

  @doc ~S"""
  Dismiss/restore a zone insight (`PUT /zones/:zone_id/security-center/insights/:issue_id/dismiss`).
  """
  def dismiss_zone_insight(client, zone_id, issue_id, params \\ %{"dismiss" => true})
      when is_map(params) do
    c(client)
    |> Tesla.put(zone_insights_path(zone_id) <> "/#{encode(issue_id)}/dismiss", params)
    |> handle_response()
  end

  defp grouped_counts(client_or_fun, path, opts) do
    c(client_or_fun)
    |> Tesla.get(with_query(path, opts))
    |> handle_response()
  end

  defp attack_surface_path(account_id),
    do: "/accounts/#{account_id}/intel/attack-surface-report"

  defp insights_path(account_id), do: "/accounts/#{account_id}/security-center/insights"
  defp zone_insights_path(zone_id), do: "/zones/#{zone_id}/security-center/insights"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(path, []), do: path
  defp with_query(path, opts), do: path <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
