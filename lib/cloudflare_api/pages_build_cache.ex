defmodule CloudflareApi.PagesBuildCache do
  @moduledoc ~S"""
  Purge the Pages build cache (`/accounts/:account_id/pages/projects/:project_name/purge_build_cache`).
  """

  @doc ~S"""
  Purge cached build artifacts for a Pages project.
  """
  def purge(client, account_id, project_name) do
    c(client)
    |> Tesla.post(purge_path(account_id, project_name), %{})
    |> handle_response()
  end

  defp purge_path(account_id, project_name) do
    "/accounts/#{account_id}/pages/projects/#{encode(project_name)}/purge_build_cache"
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
