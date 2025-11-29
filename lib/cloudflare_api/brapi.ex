defmodule CloudflareApi.Brapi do
  @moduledoc ~S"""
  Browser Rendering API (BRAPI) helpers under `/accounts/:account_id/browser-rendering`.
  """

  def render_content(client, account_id, params) when is_map(params),
    do: post(client, account_id, "content", params)

  def render_json(client, account_id, params) when is_map(params),
    do: post(client, account_id, "json", params)

  def render_links(client, account_id, params) when is_map(params),
    do: post(client, account_id, "links", params)

  def render_markdown(client, account_id, params) when is_map(params),
    do: post(client, account_id, "markdown", params)

  def render_pdf(client, account_id, params) when is_map(params),
    do: post(client, account_id, "pdf", params)

  def scrape(client, account_id, params) when is_map(params),
    do: post(client, account_id, "scrape", params)

  def screenshot(client, account_id, params) when is_map(params),
    do: post(client, account_id, "screenshot", params)

  def snapshot(client, account_id, params) when is_map(params),
    do: post(client, account_id, "snapshot", params)

  defp post(client, account_id, suffix, params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/#{suffix}", params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/browser-rendering"

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
