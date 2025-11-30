defmodule CloudflareApi.Typespecs do
  @moduledoc false

  @client_names [:client, :client_fun, :client_fn]
  @options_names [
    :opts,
    :options,
    :filters,
    :query,
    :query_opts,
    :params,
    :search_params,
    :pagination
  ]
  @map_names [:body, :payload, :data, :config, :settings, :record, :details, :attributes]
  @function_names [:fun, :callback, :handler, :predicate]
  @module_names [:module, :mod]
  @string_names [
    :hostname,
    :domain,
    :name,
    :type,
    :email,
    :host,
    :ip,
    :path,
    :route,
    :tag,
    :value,
    :zone,
    :account,
    :policy,
    :rule,
    :dataset,
    :record_name,
    :list_name,
    :secret,
    :token,
    :key,
    :url,
    :version,
    :method,
    :status,
    :identifier
  ]
  @integer_names [:ttl, :per_page, :page, :count, :limit, :offset, :duration, :priority, :weight]
  @boolean_names [:proxied, :proxiable, :locked, :enabled, :paused, :active, :flagged, :primary]
  @list_names [
    :ids,
    :items,
    :records,
    :values,
    :policies,
    :rules,
    :hostnames,
    :domains,
    :ips,
    :zones
  ]
  @id_suffixes ["_id", "_identifier"]

  @string_suffixes [
    "_name",
    "_hostname",
    "_domain",
    "_token",
    "_tag",
    "_slug",
    "_key",
    "_email",
    "_zone",
    "_account",
    "_policy",
    "_rule",
    "_dataset",
    "_record",
    "_list",
    "_secret",
    "_path",
    "_url",
    "_ip",
    "_type"
  ]
  @list_suffixes [
    "_ids",
    "_names",
    "_hostnames",
    "_domains",
    "_tags",
    "_items",
    "_records",
    "_values",
    "_policies",
    "_rules",
    "_ips",
    "_zones"
  ]

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :cf_auto_specs, accumulate: true)
      @on_definition {CloudflareApi.Typespecs, :on_definition}
      @before_compile CloudflareApi.Typespecs
    end
  end

  def on_definition(env, :def, name, args, _guards, _body) do
    Module.put_attribute(env.module, :cf_auto_specs, {name, args})
  end

  def on_definition(_env, _kind, _name, _args, _guards, _body), do: :ok

  defmacro __before_compile__(env) do
    defs = Module.get_attribute(env.module, :cf_auto_specs)
    manual_specs = manual_specs(Module.get_attribute(env.module, :spec))
    specs = build_specs(defs, manual_specs)
    spec_asts = Enum.map(specs, &spec_ast(&1, env))

    quote do
      (unquote_splicing(spec_asts))
    end
  end

  defp manual_specs(nil), do: MapSet.new()

  defp manual_specs(specs) do
    specs
    |> List.wrap()
    |> Enum.reduce(MapSet.new(), fn
      {:spec, spec_ast, _meta}, acc ->
        case spec_name_arity(spec_ast) do
          {name, arity} -> MapSet.put(acc, {name, arity})
          _ -> acc
        end

      _, acc ->
        acc
    end)
  end

  defp spec_name_arity({:"::", _, [head | _]}), do: spec_name_arity(head)
  defp spec_name_arity({:when, _, [head | _]}), do: spec_name_arity(head)

  defp spec_name_arity({name, _, args}) when is_atom(name) do
    arity =
      case args do
        nil -> 0
        list when is_list(list) -> length(list)
        _ -> 0
      end

    {name, arity}
  end

  defp spec_name_arity(_), do: nil

  defp build_specs(defs, manual_specs) do
    defs
    |> List.wrap()
    |> Enum.reduce({[], MapSet.new()}, fn {name, args}, {entries, seen} ->
      key = {name, length(args)}

      cond do
        MapSet.member?(manual_specs, key) ->
          {entries, seen}

        MapSet.member?(seen, key) ->
          {entries, seen}

        true ->
          {[{name, args} | entries], MapSet.put(seen, key)}
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp spec_ast({name, args}, env) do
    arg_types = Enum.map(args, &infer_arg_type(&1, env))
    return_type = infer_return_type(name, args)

    quote do
      @spec unquote(name)(unquote_splicing(arg_types)) :: unquote(return_type)
    end
  end

  defp infer_arg_type({:\\, _, [pattern, default]}, env) do
    type = infer_arg_type(pattern, env)

    case default do
      nil -> quote(do: unquote(type) | nil)
      _ -> type
    end
  end

  defp infer_arg_type({:=, _, [pattern, _value]}, env), do: infer_arg_type(pattern, env)

  defp infer_arg_type({:%, _, [{:__aliases__, _, _} = alias_ast, _]}, env) do
    module = expand_alias(alias_ast, env)

    quote do
      unquote(module).t()
    end
  rescue
    _ -> quote(do: struct())
  end

  defp infer_arg_type({:%, _, [{:__MODULE__, _, _}, _]}, _env), do: quote(do: struct())
  defp infer_arg_type({:%{}, _, _}, _env), do: quote(do: map())
  defp infer_arg_type([{_, _, _} | _], _env), do: quote(do: list())
  defp infer_arg_type(list, _env) when is_list(list), do: quote(do: list())
  defp infer_arg_type(literal, _env) when is_binary(literal), do: quote(do: String.t())
  defp infer_arg_type(literal, _env) when is_integer(literal), do: quote(do: integer())
  defp infer_arg_type(literal, _env) when is_float(literal), do: quote(do: float())
  defp infer_arg_type(literal, _env) when is_map(literal), do: quote(do: map())

  defp infer_arg_type({name, _, _}, _env) when is_atom(name) do
    name
    |> Atom.to_string()
    |> infer_type_from_name(name)
  end

  defp infer_arg_type(_, _env), do: quote(do: term())

  defp expand_alias(alias_ast, env) do
    alias_ast
    |> Macro.expand(env)
    |> case do
      atom when is_atom(atom) -> atom
      {:__aliases__, _, parts} -> Module.concat(parts)
    end
  end

  defp infer_type_from_name(_, name) when name in @client_names do
    quote(do: Tesla.Client.t() | (-> Tesla.Client.t()))
  end

  defp infer_type_from_name(_, name) when name in @options_names do
    quote(do: keyword() | map() | nil)
  end

  defp infer_type_from_name(_, name) when name in @map_names do
    quote(do: map())
  end

  defp infer_type_from_name(_, name) when name in @boolean_names do
    quote(do: boolean())
  end

  defp infer_type_from_name(_, name) when name in @integer_names do
    quote(do: non_neg_integer())
  end

  defp infer_type_from_name(_, name) when name in @list_names do
    quote(do: list())
  end

  defp infer_type_from_name(_, name) when name in @string_names do
    quote(do: String.t())
  end

  defp infer_type_from_name(_, name) when name in @function_names do
    quote(do: function())
  end

  defp infer_type_from_name(_, name) when name in @module_names do
    quote(do: module())
  end

  defp infer_type_from_name(string, _) when is_binary(string) do
    cond do
      String.ends_with?(string, @id_suffixes) ->
        quote(do: String.t())

      String.ends_with?(string, @list_suffixes) ->
        quote(do: list())

      String.ends_with?(string, @string_suffixes) ->
        quote(do: String.t())

      true ->
        quote(do: term())
    end
  end

  defp infer_return_type(name, args) do
    cond do
      question_name?(name) ->
        quote(do: boolean())

      has_client_arg?(args) ->
        quote(do: {:ok, term()} | {:error, term()})

      true ->
        quote(do: term())
    end
  end

  defp question_name?(name) do
    name
    |> Atom.to_string()
    |> String.ends_with?("?")
  end

  defp has_client_arg?(args) do
    Enum.any?(args, fn arg ->
      case arg do
        {:\\, _, [pattern, _]} -> arg_name(pattern)
        {:=, _, [pattern, _]} -> arg_name(pattern)
        _ -> arg_name(arg)
      end in @client_names
    end)
  end

  defp arg_name({name, _, _}) when is_atom(name), do: name
  defp arg_name(_), do: nil
end
