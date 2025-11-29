defmodule CloudflareApi.BrapiTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Brapi

  @base "https://api.cloudflare.com/client/v4/accounts/acct/browser-rendering"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  test "individual render helpers POST to the right suffix", %{client: client} do
    responses = [
      :render_content,
      :render_json,
      :render_links,
      :render_markdown,
      :render_pdf,
      :scrape,
      :screenshot,
      :snapshot
    ]

    mock(fn %Tesla.Env{method: :post, url: url, body: body} = env ->
      assert Jason.decode!(body) == %{"html" => "<html></html>"}
      assert url in Enum.map(responses, &("#{@base}/" <> suffix(&1)))
      {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"id" => url}}}}
    end)

    Enum.each(responses, fn fun ->
      assert {:ok, %{"id" => url}} =
               apply(Brapi, fun, [client, "acct", %{"html" => "<html></html>"}])

      assert String.starts_with?(url, @base)
    end)
  end

  test "errors bubble", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 422, body: %{"errors" => [%{"code" => 81}]}}}
    end)

    assert {:error, [%{"code" => 81}]} =
             Brapi.render_content(client, "acct", %{"html" => ""})
  end

  defp suffix(:render_content), do: "content"
  defp suffix(:render_json), do: "json"
  defp suffix(:render_links), do: "links"
  defp suffix(:render_markdown), do: "markdown"
  defp suffix(:render_pdf), do: "pdf"
  defp suffix(:scrape), do: "scrape"
  defp suffix(:screenshot), do: "screenshot"
  defp suffix(:snapshot), do: "snapshot"
end
