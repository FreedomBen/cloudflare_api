defmodule CloudflareApi.WorkersAi do
  @moduledoc ~S"""
  Workers AI helpers for model metadata, execution, and markdown conversion.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  Search authors (`GET /accounts/:account_id/ai/authors/search`).
  """
  def search_authors(client, account_id) do
    c(client)
    |> Tesla.get(authors_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Fetch a model schema (`GET /accounts/:account_id/ai/models/schema?model=...`).
  """
  def get_model_schema(client, account_id, model) do
    c(client)
    |> Tesla.get(with_query(models_schema_path(account_id), model: model))
    |> handle_response()
  end

  @doc ~S"""
  Search available models (`GET /accounts/:account_id/ai/models/search`).

  Supports query filters like `:task`, `:author`, `:source`, `:hide_experimental`,
  `:search`, `:page`, and `:per_page`.
  """
  def search_models(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(models_search_path(account_id), opts))
    |> handle_response()
  end

  @doc ~S"""
  Execute an AI model (`POST /accounts/:account_id/ai/run/:model_name`).
  """
  def run_model(client, account_id, model_name, params \\ %{}) do
    c(client)
    |> Tesla.post(run_path(account_id, model_name), params)
    |> handle_response()
  end

  @doc ~S"""
  Search tasks (`GET /accounts/:account_id/ai/tasks/search`).
  """
  def search_tasks(client, account_id) do
    c(client)
    |> Tesla.get(tasks_path(account_id))
    |> handle_response()
  end

  @doc ~S"""
  Convert files to Markdown (`POST /accounts/:account_id/ai/tomarkdown`).

  Accepts an IO data payload plus optional headers. A `content-type` header of
  `application/octet-stream` is applied when not provided.
  """
  def convert_to_markdown(client, account_id, body, headers \\ []) do
    headers = ensure_content_type(headers, "application/octet-stream")

    c(client)
    |> Tesla.post(to_markdown_path(account_id), body, headers: headers)
    |> handle_response()
  end

  @doc ~S"""
  List supported formats for Markdown conversion (`GET .../tomarkdown/supported`).
  """
  def supported_markdown_formats(client, account_id) do
    c(client)
    |> Tesla.get(to_markdown_supported_path(account_id))
    |> handle_response()
  end

  defp authors_path(account_id), do: "/accounts/#{account_id}/ai/authors/search"
  defp models_schema_path(account_id), do: "/accounts/#{account_id}/ai/models/schema"
  defp models_search_path(account_id), do: "/accounts/#{account_id}/ai/models/search"

  defp run_path(account_id, model_name),
    do: "/accounts/#{account_id}/ai/run/#{encode(model_name)}"

  defp tasks_path(account_id), do: "/accounts/#{account_id}/ai/tasks/search"
  defp to_markdown_path(account_id), do: "/accounts/#{account_id}/ai/tomarkdown"

  defp to_markdown_supported_path(account_id),
    do: "/accounts/#{account_id}/ai/tomarkdown/supported"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

  defp ensure_content_type(headers, default) do
    if Enum.any?(headers, fn {key, _} ->
         String.downcase(to_string(key)) == "content-type"
       end) do
      headers
    else
      [{"content-type", default} | headers]
    end
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
