defmodule CloudflareApi.TsengAbuseComplaintProcessorOther do
  @moduledoc ~S"""
  Wraps the "tseng-abuse-complaint-processor" endpoints for managing abuse reports,
  mitigations, and mitigation appeals under `/accounts/:account_id/abuse-reports`.
  """

  use CloudflareApi.Typespecs

  @doc ~S"""
  List abuse reports for an account (`GET /accounts/:account_id/abuse-reports`).

  Supports pagination and filtering options such as `:page`, `:per_page`,
  `:domain`, `:status`, and more via `opts`.
  """
  def list_reports(client, account_id, opts \\ []) do
    request(client, :get, with_query(base_path(account_id), opts))
  end

  @doc ~S"""
  Fetch a single abuse report (`GET /accounts/:account_id/abuse-reports/:report_id`).
  """
  def get_report(client, account_id, report_param) do
    request(client, :get, report_path(account_id, report_param))
  end

  @doc ~S"""
  Submit an abuse report (`POST /accounts/:account_id/abuse-reports/:report_type`).

  The `report_type` segment matches the submission type (for example `abuse_general`).
  Provide a map adhering to the `abuse-reports_SubmitReportRequest` schema.
  """
  def submit_report(client, account_id, report_type, params) when is_map(params) do
    request(client, :post, report_path(account_id, report_type), params)
  end

  @doc ~S"""
  List mitigations tied to a report (`GET /accounts/:account_id/abuse-reports/:report_id/mitigations`).

  Accepts pagination/filtering options such as `:status`, `:type`, or `:entity_type`.
  """
  def list_mitigations(client, account_id, report_id, opts \\ []) do
    request(client, :get, with_query(mitigations_path(account_id, report_id), opts))
  end

  @doc ~S"""
  Request a mitigation review (`POST /accounts/:account_id/abuse-reports/:report_id/mitigations/appeal`).

  Pass a map with the mitigation identifiers and justification text per the
  `abuse-reports_MitigationAppealRequest` schema.
  """
  def request_review(client, account_id, report_id, params) when is_map(params) do
    request(client, :post, appeal_path(account_id, report_id), params)
  end

  defp base_path(account_id), do: "/accounts/#{account_id}/abuse-reports"

  defp report_path(account_id, report_param),
    do: base_path(account_id) <> "/#{encode(report_param)}"

  defp mitigations_path(account_id, report_id),
    do: report_path(account_id, report_id) <> "/mitigations"

  defp appeal_path(account_id, report_id),
    do: mitigations_path(account_id, report_id) <> "/appeal"

  defp with_query(url, []), do: url
  defp with_query(url, opts), do: url <> "?" <> encode_opts(opts)

  defp encode_opts(opts) do
    opts
    |> Enum.flat_map(fn
      {key, values} when is_list(values) -> Enum.map(values, &{key, &1})
      pair -> [pair]
    end)
    |> CloudflareApi.uri_encode_opts()
  end

  defp request(client, method, url, body \\ nil) do
    client = c(client)

    result =
      case method do
        :get -> Tesla.get(client, url)
        :post -> Tesla.post(client, url, body || %{})
      end

    handle_response(result)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: %{"result" => result}}})
       when status in 200..299,
       do: {:ok, result}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299 and is_map(body),
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}})
       when status in 200..299,
       do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{body: %{"errors" => errors}}}), do: {:error, errors}
  defp handle_response(other), do: {:error, other}

  defp encode(value), do: value |> to_string() |> URI.encode(&URI.char_unreserved?/1)

  defp c(%Tesla.Client{} = client), do: client
  defp c(fun) when is_function(fun, 0), do: fun.()
end
