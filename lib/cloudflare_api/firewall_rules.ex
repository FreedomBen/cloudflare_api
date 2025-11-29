defmodule CloudflareApi.FirewallRules do
  @moduledoc ~S"""
  Zone firewall rule helpers for `/zones/:zone_id/firewall/rules`.
  """

  @doc ~S"""
  List firewall rules for a zone (`GET /zones/:zone_id/firewall/rules`).

  Accepts optional filters via `opts`, including:

    * `:description` – case-insensitive substring match on the description.
    * `:action` – match a specific rule action.
    * `:id` – filter by rule identifier.
    * `:paused` – boolean pause filter.
    * `:page` / `:per_page` – pagination controls.
  """
  def list(client, zone_id, opts \\ []) do
    request(client, :get, base_path(zone_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Create one or more firewall rules (`POST /zones/:zone_id/firewall/rules`).

  Accepts either a single map or list of maps shaped according to the
  Cloudflare schema (action, filter, description, etc).
  """
  def create(client, zone_id, rules) do
    with {:ok, payload} <- ensure_rule_maps(rules) do
      request(client, :post, base_path(zone_id), payload)
    end
  end

  @doc ~S"""
  Update one or more firewall rules (`PUT /zones/:zone_id/firewall/rules`).

  Payload entries must include their `id`.
  """
  def update_many(client, zone_id, rules) do
    with {:ok, payload} <- ensure_rule_maps(rules) do
      request(client, :put, base_path(zone_id), payload)
    end
  end

  @doc ~S"""
  Update rule priorities in bulk (`PATCH /zones/:zone_id/firewall/rules`).

  Provide a map or list of maps that include `id` and `priority`.
  """
  def update_priorities(client, zone_id, updates) do
    with {:ok, payload} <- ensure_rule_maps(updates) do
      request(client, :patch, base_path(zone_id), payload)
    end
  end

  @doc ~S"""
  Delete multiple firewall rules (`DELETE /zones/:zone_id/firewall/rules`).

  `rules` may be a string/integer id, a map containing an `id`, or a list of
  either. Use `opts[:delete_filter_if_unused]` to cascade filter deletion.
  """
  def delete_many(client, zone_id, rules, opts \\ []) do
    delete_flag = Keyword.get(opts, :delete_filter_if_unused)

    with {:ok, payload} <- ensure_rule_delete_payload(rules, delete_flag) do
      request(client, :delete, base_path(zone_id), payload)
    end
  end

  @doc ~S"""
  Retrieve a single firewall rule (`GET /zones/:zone_id/firewall/rules/:rule_id`).
  """
  def get(client, zone_id, rule_id, opts \\ []) do
    request(client, :get, rule_path(zone_id, rule_id) <> query_suffix(opts))
  end

  @doc ~S"""
  Update a single firewall rule (`PUT /zones/:zone_id/firewall/rules/:rule_id`).
  """
  def update(client, zone_id, rule_id, params) when is_map(params) do
    body = Map.put(params, "id", to_string(rule_id))
    request(client, :put, rule_path(zone_id, rule_id), body)
  end

  @doc ~S"""
  Update a rule's priority (`PATCH /zones/:zone_id/firewall/rules/:rule_id`).
  """
  def update_priority(client, zone_id, rule_id, params) when is_map(params) do
    body = Map.put(params, "id", to_string(rule_id))
    request(client, :patch, rule_path(zone_id, rule_id), body)
  end

  @doc ~S"""
  Delete a single firewall rule (`DELETE /zones/:zone_id/firewall/rules/:rule_id`).
  """
  def delete(client, zone_id, rule_id, opts \\ []) do
    body =
      case Keyword.fetch(opts, :delete_filter_if_unused) do
        {:ok, value} -> %{"delete_filter_if_unused" => value}
        :error -> %{}
      end

    request(client, :delete, rule_path(zone_id, rule_id), body)
  end

  defp base_path(zone_id), do: "/zones/#{zone_id}/firewall/rules"
  defp rule_path(zone_id, rule_id), do: base_path(zone_id) <> "/#{rule_id}"

  defp query_suffix([]), do: ""
  defp query_suffix(opts), do: "?" <> CloudflareApi.uri_encode_opts(opts)

  defp ensure_rule_maps(rules) when is_list(rules) and rules != [] do
    if Enum.all?(rules, &is_map/1) do
      {:ok, rules}
    else
      {:error, :invalid_rule_payload}
    end
  end

  defp ensure_rule_maps([]), do: {:error, :no_rules}
  defp ensure_rule_maps(rule) when is_map(rule), do: {:ok, [rule]}
  defp ensure_rule_maps(_), do: {:error, :invalid_rule_payload}

  defp ensure_rule_delete_payload(rules, delete_flag) when is_list(rules) and rules != [] do
    rules
    |> Enum.reduce_while({:ok, []}, fn entry, {:ok, acc} ->
      case normalize_delete_entry(entry, delete_flag) do
        {:ok, normalized} -> {:cont, {:ok, [normalized | acc]}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
    |> case do
      {:ok, acc} -> {:ok, Enum.reverse(acc)}
      other -> other
    end
  end

  defp ensure_rule_delete_payload([], _), do: {:error, :no_rule_ids}

  defp ensure_rule_delete_payload(rule, delete_flag) do
    case normalize_delete_entry(rule, delete_flag) do
      {:ok, normalized} -> {:ok, [normalized]}
      other -> other
    end
  end

  defp normalize_delete_entry(%{"id" => id} = rule, delete_flag) when not is_nil(id) do
    {:ok, rule |> Map.put("id", to_string(id)) |> maybe_put_delete_flag(delete_flag)}
  end

  defp normalize_delete_entry(%{id: id} = rule, delete_flag) when not is_nil(id) do
    {:ok,
     rule
     |> Map.put("id", to_string(id))
     |> maybe_put_delete_flag(delete_flag)}
  end

  defp normalize_delete_entry(%{} = _rule, _), do: {:error, :missing_rule_id}

  defp normalize_delete_entry(id, delete_flag) when is_binary(id) or is_integer(id) do
    {:ok, %{"id" => to_string(id)} |> maybe_put_delete_flag(delete_flag)}
  end

  defp normalize_delete_entry(_, _), do: {:error, :invalid_rule_id}

  defp maybe_put_delete_flag(entry, nil), do: entry

  defp maybe_put_delete_flag(entry, value) do
    if Map.has_key?(entry, "delete_filter_if_unused") or
         Map.has_key?(entry, :delete_filter_if_unused) do
      entry
    else
      Map.put(entry, "delete_filter_if_unused", value)
    end
  end

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case {method, body} do
        {:get, _} ->
          Tesla.get(client, url)

        {:post, payload} ->
          Tesla.post(client, url, payload)

        {:put, payload} ->
          Tesla.put(client, url, payload)

        {:patch, payload} ->
          Tesla.patch(client, url, payload)

        {:delete, nil} ->
          Tesla.delete(client, url)

        {:delete, payload} ->
          Tesla.delete(client, url, body: payload)
      end

    handle_response(result)
  end

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
