defmodule CloudflareApi.Workflows do
  @moduledoc ~S"""
  Manage Workers Workflows (`/accounts/:account_id/workflows`), including
  workflow definitions, instances, batch termination, events, and versions.
  """

  @doc """
  List workflows (`GET /accounts/:account_id/workflows`).

  Supports `:page`, `:per_page`, and `:search`.
  """
  def list(client, account_id, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(base_path(account_id), opts))
    |> handle_response()
  end

  @doc """
  Create or modify a workflow (`PUT /accounts/:account_id/workflows/:workflow_name`).
  """
  def create_or_update(client, account_id, workflow_name, params) when is_map(params) do
    c(client)
    |> Tesla.put(workflow_path(account_id, workflow_name), params)
    |> handle_response()
  end

  @doc """
  Get workflow details (`GET /accounts/:account_id/workflows/:workflow_name`).
  """
  def get(client, account_id, workflow_name) do
    c(client)
    |> Tesla.get(workflow_path(account_id, workflow_name))
    |> handle_response()
  end

  @doc """
  Delete a workflow (`DELETE /accounts/:account_id/workflows/:workflow_name`).
  """
  def delete(client, account_id, workflow_name) do
    c(client)
    |> Tesla.delete(workflow_path(account_id, workflow_name), body: %{})
    |> handle_response()
  end

  @doc """
  List workflow versions (`GET .../versions`).
  """
  def list_versions(client, account_id, workflow_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(versions_path(account_id, workflow_name), opts))
    |> handle_response()
  end

  @doc """
  Get workflow version details (`GET .../versions/:version_id`).
  """
  def get_version(client, account_id, workflow_name, version_id) do
    c(client)
    |> Tesla.get(version_path(account_id, workflow_name, version_id))
    |> handle_response()
  end

  @doc """
  List workflow instances (`GET .../instances`).

  Supports pagination and filters such as `:status`, `:direction`, `:date_start`, `:date_end`.
  """
  def list_instances(client, account_id, workflow_name, opts \\ []) do
    c(client)
    |> Tesla.get(with_query(instances_path(account_id, workflow_name), opts))
    |> handle_response()
  end

  @doc """
  Create a workflow instance (`POST .../instances`).
  """
  def create_instance(client, account_id, workflow_name, params \\ %{}) do
    c(client)
    |> Tesla.post(instances_path(account_id, workflow_name), params)
    |> handle_response()
  end

  @doc """
  Batch create workflow instances (`POST .../instances/batch`).
  """
  def batch_create_instances(client, account_id, workflow_name, params \\ %{}) do
    c(client)
    |> Tesla.post(batch_instances_path(account_id, workflow_name), params)
    |> handle_response()
  end

  @doc """
  Batch terminate workflow instances (`POST .../instances/batch/terminate`).
  """
  def batch_terminate_instances(client, account_id, workflow_name, params \\ %{}) do
    c(client)
    |> Tesla.post(batch_terminate_path(account_id, workflow_name), params)
    |> handle_response()
  end

  @doc """
  Query batch termination status (`GET .../instances/terminate`).
  """
  def batch_termination_status(client, account_id, workflow_name) do
    c(client)
    |> Tesla.get(batch_termination_status_path(account_id, workflow_name))
    |> handle_response()
  end

  @doc """
  Describe an instance (`GET .../instances/:instance_id`).
  """
  def get_instance(client, account_id, workflow_name, instance_id) do
    c(client)
    |> Tesla.get(instance_path(account_id, workflow_name, instance_id))
    |> handle_response()
  end

  @doc """
  Send an event to an instance (`POST .../instances/:instance_id/events/:event_type`).
  """
  def send_event(client, account_id, workflow_name, instance_id, event_type, params \\ %{}) do
    c(client)
    |> Tesla.post(event_path(account_id, workflow_name, instance_id, event_type), params)
    |> handle_response()
  end

  @doc """
  Change instance status (`PATCH .../instances/:instance_id/status`).
  """
  def change_status(client, account_id, workflow_name, instance_id, params \\ %{}) do
    c(client)
    |> Tesla.patch(status_path(account_id, workflow_name, instance_id), params)
    |> handle_response()
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/workflows"

  defp workflow_path(account_id, workflow_name),
    do: base_path(account_id) <> "/#{encode(workflow_name)}"

  defp versions_path(account_id, workflow_name),
    do: workflow_path(account_id, workflow_name) <> "/versions"

  defp version_path(account_id, workflow_name, version_id),
    do: versions_path(account_id, workflow_name) <> "/#{encode(version_id)}"

  defp instances_path(account_id, workflow_name),
    do: workflow_path(account_id, workflow_name) <> "/instances"

  defp batch_instances_path(account_id, workflow_name),
    do: instances_path(account_id, workflow_name) <> "/batch"

  defp batch_terminate_path(account_id, workflow_name),
    do: batch_instances_path(account_id, workflow_name) <> "/terminate"

  defp batch_termination_status_path(account_id, workflow_name),
    do: instances_path(account_id, workflow_name) <> "/terminate"

  defp instance_path(account_id, workflow_name, instance_id),
    do: instances_path(account_id, workflow_name) <> "/#{encode(instance_id)}"

  defp event_path(account_id, workflow_name, instance_id, event_type),
    do: instance_path(account_id, workflow_name, instance_id) <> "/events/#{encode(event_type)}"

  defp status_path(account_id, workflow_name, instance_id),
    do: instance_path(account_id, workflow_name, instance_id) <> "/status"

  defp encode(value), do: value |> to_string() |> URI.encode_www_form()

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> CloudflareApi.uri_encode_opts(opts)

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
