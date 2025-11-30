defmodule CloudflareApi.Accounts do
  @moduledoc ~S"""
  Helpers for listing and fetching Cloudflare accounts.

  These functions map to the `/accounts` endpoints documented in Cloudflare's
  API reference. They accept either a `Tesla.Client.t()` or a zero-arity
  function returned by `CloudflareApi.client/1`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List accounts available to the authenticated user.

  Supports the standard Cloudflare filters (for example `name`, `status`,
  pagination fields, etc.) via the `opts` keyword list.
  """
  def list(client, opts \\ nil) do
    case Tesla.get(c(client), list_url(opts)) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  Fetch a single account by its identifier (`GET /accounts/:account_id`).
  """
  def get(client, account_id) do
    case Tesla.get(c(client), "/accounts/#{account_id}") do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body["result"]}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  defp list_url(nil), do: "/accounts"
  defp list_url(opts), do: "/accounts?#{CloudflareApi.uri_encode_opts(opts)}"

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
