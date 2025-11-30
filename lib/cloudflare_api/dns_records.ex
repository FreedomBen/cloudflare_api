defmodule CloudflareApi.DnsRecords do
  @moduledoc ~S"""
  Helpers for working with Cloudflare DNS records.

  This module wraps the [DNS Records for a zone](https://api.cloudflare.com/#dns-records-for-a-zone-properties)
  endpoints and exposes a small, Elixir-friendly surface for listing, creating,
  updating and deleting records. It also includes a few convenience helpers for
  common existence checks.

  All public functions expect either a `Tesla.Client.t()` built via
  `CloudflareApi.new/1` or a zero-arity function returned by `CloudflareApi.client/1`.
  """

  use CloudflareApi.Typespecs

  alias CloudflareApi.DnsRecord

  @doc ~S"""
  List DNS records for a zone.

  This is a thin wrapper around `GET /zones/:zone_identifier/dns_records`.

  - `client` – a `Tesla.Client.t()` or a zero-arity function returning one
  - `zone_id` – the Cloudflare zone identifier
  - `opts` – an optional keyword list of query parameters supported by the
    Cloudflare API (for example `name: "www.example.com", type: "A"`)

  On success, returns `{:ok, [CloudflareApi.DnsRecord.t()]}`. If Cloudflare
  responds with an `errors` list, returns `{:error, errors}`. Any other
  unexpected response shape is wrapped as `{:error, err}`.
  """
  def list(client, zone_id, opts \\ nil) do
    case Tesla.get(c(client), list_url(zone_id, opts)) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, to_structs(body["result"])}
      {:ok, %Tesla.Env{body: %{"errors" => errs}}} -> {:error, errs}
      err -> {:error, err}
    end
  end

  @doc ~S"""
  List DNS records for a specific hostname.

  This is a convenience wrapper around `list/3` that always filters by the
  fully-qualified `hostname` and optionally by record `type` (for example `"A"`,
  `"AAAA"`, `"CNAME"`).
  """
  def list_for_hostname(client, zone_id, hostname, type \\ nil) do
    opts =
      case type do
        nil -> [name: hostname]
        type -> [name: hostname, type: type]
      end

    list(client, zone_id, opts)
  end

  @doc ~S"""
  List DNS records using a host and domain pair.

  This helper constructs a hostname from `host` and `domain` before delegating
  to `list_for_hostname/4`. If `host` already ends with `domain`, it will be
  used as-is; otherwise `"#{host}.#{domain}"` is used.
  """
  def list_for_host_domain(client, zone_id, host, domain, type \\ nil) do
    hostname =
      cond do
        String.ends_with?(host, domain) -> host
        true -> "#{host}.#{domain}"
      end

    list_for_hostname(client, zone_id, hostname, type)
  end

  @doc ~S"""
  Create a DNS record from a `CloudflareApi.DnsRecord` struct.

  This is a thin wrapper around `POST /zones/:zone_identifier/dns_records` that
  converts the struct into the JSON shape Cloudflare expects.

  Returns:

    * `{:ok, %CloudflareApi.DnsRecord{}}` on success
    * `{:ok, :already_exists}` when Cloudflare reports error code `81057`
      (record already exists)
    * `{:error, errors}` when Cloudflare returns an `errors` list
    * `{:error, err}` for any other unexpected response
  """
  def create(client, zone_id, %DnsRecord{} = record) do
    case Tesla.post(c(client), "/zones/#{zone_id}/dns_records", DnsRecord.to_cf_json(record)) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, to_struct(body["result"])}

      {:ok, %Tesla.Env{status: 400, body: %{"errors" => [%{"code" => 81_057}]}}} ->
        {:ok, :already_exists}

      {:ok, %Tesla.Env{body: %{"errors" => errs}}} ->
        {:error, errs}

      err ->
        {:error, err}
    end
  end

  @doc ~S"""
  Create a DNS record from individual fields.

  This is a convenience wrapper around `create/3` that builds a minimal
  Cloudflare DNS record from the given arguments.

  - `hostname` – the record name, for example `"www.example.com"`
  - `ip` – the record content, typically an IPv4 or IPv6 address
  - `type` – the Cloudflare DNS record type, defaulting to `"A"`

  Returns the same tuple shapes as `create/3`, but uses `{:ok, :already_created}`
  when Cloudflare reports that the record already exists.
  """
  def create(client, zone_id, hostname, ip, type \\ "A") do
    case Tesla.post(c(client), "/zones/#{zone_id}/dns_records", %{
           type: type,
           name: hostname,
           content: ip,
           ttl: 1,
           proxied: false
         }) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, to_struct(body["result"])}

      {:ok, %Tesla.Env{status: 400, body: %{"errors" => [%{"code" => 81_057}]}}} ->
        {:ok, :already_created}

      {:ok, %Tesla.Env{body: %{"errors" => errs}}} ->
        {:error, errs}

      err ->
        {:error, err}
    end
  end

  @doc ~S"""
  Update an existing DNS record.

  This wraps `PUT /zones/:zone_identifier/dns_records/:identifier` and replaces
  the basic fields of an existing record (type, name, content, ttl, proxied).

  On success it returns `{:ok, %CloudflareApi.DnsRecord{}}`. When Cloudflare
  responds with an `errors` list, it returns `{:error, errors}`; all other
  failures are normalized as `{:error, err}`.
  """
  def update(client, zone_id, record_id, hostname, ip, type \\ "A") do
    case Tesla.put(c(client), "/zones/#{zone_id}/dns_records/#{record_id}", %{
           type: type,
           name: hostname,
           content: ip,
           ttl: 1,
           proxied: false
         }) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, to_struct(body["result"])}

      {:ok, %Tesla.Env{body: %{"errors" => errs}}} ->
        {:error, errs}

      err ->
        {:error, err}
    end
  end

  @doc ~S"""
  Delete a DNS record from a zone.

  This wraps `DELETE /zones/:zone_identifier/dns_records/:identifier`.

  Returns:

    * `{:ok, id}` when the record is successfully deleted
    * `{:ok, :already_deleted}` when Cloudflare reports error code `81044`
    * `{:error, errors}` when Cloudflare returns an `errors` list
    * `{:error, err}` for other failures
  """
  def delete(client, zone_id, record_id) do
    # The OpenAPI schema models this endpoint with a required (but empty) JSON
    # request body, so we send an empty map here to align with that shape.
    case Tesla.delete(c(client), "/zones/#{zone_id}/dns_records/#{record_id}", body: %{}) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body["result"]["id"]}

      {:ok, %Tesla.Env{status: 404, body: %{"errors" => [%{"code" => 81_044}]}}} ->
        {:ok, :already_deleted}

      {:ok, %Tesla.Env{body: %{"errors" => errs}}} ->
        {:error, errs}

      err ->
        {:error, err}
    end
  end

  @doc ~S"""
  Check whether any records exist for a given hostname.

  This calls `list_for_hostname/4` and returns a boolean indicating whether the
  returned list is non-empty. If the underlying `list_for_hostname/4` call
  returns an error tuple, a `MatchError` will be raised.
  """
  def hostname_exists?(client, zone_id, hostname, type \\ nil) do
    with {:ok, records} = list_for_hostname(client, zone_id, hostname, type) do
      Enum.count(records) > 0
    end
  end

  @doc ~S"""
  Check whether any records exist for a given host and domain pair.

  This is the `host`/`domain` equivalent of `hostname_exists?/4` and delegates
  to `list_for_host_domain/5`. As with `hostname_exists?/4`, a `MatchError`
  will be raised if the underlying call returns an error tuple.
  """
  def host_domain_exists?(client, zone_id, host, domain, type \\ nil) do
    with {:ok, records} = list_for_host_domain(client, zone_id, host, domain, type) do
      Enum.count(records) > 0
    end
  end

  defp list_url(zone_id, opts) do
    case opts do
      nil -> "/zones/#{zone_id}/dns_records"
      _ -> "/zones/#{zone_id}/dns_records?#{CloudflareApi.uri_encode_opts(opts)}"
    end
  end

  defp c(%Tesla.Client{} = client), do: client
  defp c(client), do: client.()

  defp to_structs(records) when is_list(records),
    do: Enum.map(records, fn r -> to_struct(r) end)

  defp to_struct(record), do: DnsRecord.from_cf_json(record)
end
