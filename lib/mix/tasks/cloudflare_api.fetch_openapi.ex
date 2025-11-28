defmodule Mix.Tasks.CloudflareApi.FetchOpenapi do
  @moduledoc """
  Fetches and caches the latest Cloudflare API OpenAPI schema.

  The schema is downloaded from the official Cloudflare API schemas
  repository and written to a stable location under `priv/` so it can
  be inspected or used by tooling.

      mix cloudflare_api.fetch_openapi
  """

  use Mix.Task

  @shortdoc "Download and cache the latest Cloudflare OpenAPI schema"

  @schema_url "https://raw.githubusercontent.com/cloudflare/api-schemas/refs/heads/main/openapi.json"

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")

    Mix.shell().info("Fetching Cloudflare OpenAPI schema...")

    client = Tesla.client([])

    case Tesla.get(client, @schema_url) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        path = cache_path()
        File.mkdir_p!(Path.dirname(path))
        File.write!(path, body)

        Mix.shell().info("Saved Cloudflare OpenAPI schema to: #{path}")

      {:ok, %Tesla.Env{status: status, body: body}} ->
        Mix.raise("""
        Failed to fetch Cloudflare OpenAPI schema.
        HTTP status: #{status}
        Body (truncated): #{inspect(truncate_body(body))}
        """)

      {:error, reason} ->
        Mix.raise("Failed to fetch Cloudflare OpenAPI schema: #{inspect(reason)}")
    end
  end

  defp cache_path do
    app = Mix.Project.config()[:app] || :cloudflare_api
    Path.join([File.cwd!(), "priv", Atom.to_string(app), "openapi.json"])
  end

  defp truncate_body(body) when is_binary(body) do
    max = 500

    if byte_size(body) > max do
      binary_part(body, 0, max) <> "..."
    else
      body
    end
  end

  defp truncate_body(body), do: body
end

