defmodule CloudflareApi.Triggers do
  @moduledoc ~S"""
  Manage build triggers under `/accounts/:account_id/builds/triggers`.
  """

  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base(account_id), params)
    |> handle_response()
  end

  def update(client, account_id, trigger_id, params) when is_map(params) do
    c(client)
    |> Tesla.patch(trigger_path(account_id, trigger_id), params)
    |> handle_response()
  end

  def delete(client, account_id, trigger_id) do
    c(client)
    |> Tesla.delete(trigger_path(account_id, trigger_id), body: %{})
    |> handle_response()
  end

  def create_manual_build(client, account_id, trigger_id, params \\ %{}) do
    c(client)
    |> Tesla.post(trigger_path(account_id, trigger_id) <> "/builds", params)
    |> handle_response()
  end

  def purge_build_cache(client, account_id, trigger_id, params \\ %{}) do
    c(client)
    |> Tesla.post(trigger_path(account_id, trigger_id) <> "/purge_build_cache", params)
    |> handle_response()
  end

  defp base(account_id), do: "/accounts/#{account_id}/builds/triggers"

  defp trigger_path(account_id, trigger_id) do
    base(account_id) <> "/#{encode(trigger_id)}"
  end

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
