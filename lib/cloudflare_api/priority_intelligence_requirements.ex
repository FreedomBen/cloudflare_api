defmodule CloudflareApi.PriorityIntelligenceRequirements do
  @moduledoc ~S"""
  Cloudforce One Priority Intelligence Requirements (PIR) helpers under
  `/accounts/:account_id/cloudforce-one/requests/priority`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List priority requests (`POST /requests/priority`).
  """
  def list(client, account_id, params \\ %{}) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Create a new priority request (`POST /requests/priority/new`).
  """
  def create(client, account_id, params) when is_map(params) do
    c(client)
    |> Tesla.post(base_path(account_id) <> "/new", params)
    |> handle_response()
  end

  @doc ~S"""
  Retrieve quota information (`GET /requests/priority/quota`).
  """
  def quota(client, account_id) do
    c(client)
    |> Tesla.get(base_path(account_id) <> "/quota")
    |> handle_response()
  end

  @doc ~S"""
  Fetch a priority request (`GET /requests/priority/:priority_id`).
  """
  def get(client, account_id, priority_id) do
    c(client)
    |> Tesla.get(priority_path(account_id, priority_id))
    |> handle_response()
  end

  @doc ~S"""
  Update a priority request (`PUT /requests/priority/:priority_id`).
  """
  def update(client, account_id, priority_id, params) when is_map(params) do
    c(client)
    |> Tesla.put(priority_path(account_id, priority_id), params)
    |> handle_response()
  end

  @doc ~S"""
  Delete a priority request (`DELETE /requests/priority/:priority_id`).
  """
  def delete(client, account_id, priority_id) do
    c(client)
    |> Tesla.delete(priority_path(account_id, priority_id), body: %{})
    |> handle_response()
  end

  defp base_path(account_id),
    do: "/accounts/#{account_id}/cloudforce-one/requests/priority"

  defp priority_path(account_id, priority_id),
    do: base_path(account_id) <> "/#{encode(priority_id)}"

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
