defmodule CloudflareApi.Cache do
  @moduledoc """
  An optional short-term cache for API lookups.

  This lets you repeat the same requests multiple times without
  actually making a call to the Cloudflare API.  This will help a lot
  with rate limiting.  For example if you have code that queries the
  records for a particular hostname many times, this cache will allow
  you to repeat the call many times per minute and a real API call will
  only go out once every <cache-interval>.
  """

  use GenServer

  alias CloudflareApi.DnsRecord

  alias CloudflareApi.Utils
  alias CloudflareApi.Utils.Logger

  alias CloudflareApi.{Cache, CacheEntry}

  @self :cloudflare_api_cache

  @enforce_keys [:expire_seconds, :hostnames]
  defstruct expire_seconds: 120, hostnames: %{}

  @type t :: %__MODULE__{
          expire_seconds: non_neg_integer(),
          hostnames: %{String.t() => CloudflareApi.CacheEntry.t()}
        }

  @doc ~S"""
  Start the cache GenServer.

  This is invoked by the application supervision tree and usually does not
  need to be called directly.
  """
  def start_link(args) when is_list(args) do
    Logger.debug(__ENV__, "Starting cache link with: #{Utils.to_string(args)}")
    GenServer.start_link(__MODULE__, args, name: @self)
  end

  @doc ~S"""
  Fetch a cached `CloudflareApi.DnsRecord` for the given hostname.

  If the hostname is not in the cache or the entry has expired, this function
  returns `nil`.
  """
  def get(hostname) do
    case get_entry(hostname) do
      %CacheEntry{dns_record: dns_record} -> dns_record
      nil -> nil
    end
  end

  @doc ~S"""
  Fetch a cached record even if it is expired.

  This is primarily useful for debugging; it bypasses the expiration check
  and returns whatever entry is stored for `hostname`, if any.
  """
  def get(hostname, :even_if_expired) do
    case get_entry(hostname, :even_if_expired) do
      %CacheEntry{dns_record: dns_record} -> dns_record
      nil -> nil
    end
  end

  @doc ~S"""
  Return the full `CloudflareApi.CacheEntry` for `hostname`, or `nil` if it is
  missing or expired.
  """
  def get_entry(hostname) do
    GenServer.call(@self, {:get, hostname})
  end

  @doc ~S"""
  Return the full cache entry for `hostname`, even if it has expired.
  """
  def get_entry(hostname, :even_if_expired) do
    GenServer.call(@self, {:get, hostname, :even_if_expired})
  end

  @doc ~S"""
  Insert or update a cache entry using the record’s own hostname.

  The record will be timestamped with the current monotonic time and will
  expire after `expire_seconds`.
  """
  def add_or_update(%DnsRecord{} = record) do
    # GenServer.call(@self, {:update, record})
    GenServer.call(@self, {:update, record}, 15_000)
  end

  @doc ~S"""
  Insert or update a cache entry under an explicit `hostname`.

  This is useful when you want to cache a record under a different key than
  its `record.hostname` field.
  """
  def add_or_update(hostname, %DnsRecord{} = record) do
    # GenServer.call(@self, {:update, hostname, record})
    GenServer.call(@self, {:update, hostname, record}, 15_000)
  end

  @doc ~S"""
  Alias for `add_or_update/1`.
  """
  def update(%DnsRecord{} = record), do: add_or_update(record)

  @doc ~S"""
  Alias for `add_or_update/2`.
  """
  def update(hostname, %DnsRecord{} = record), do: add_or_update(hostname, record)

  @doc ~S"""
  Check whether the cache currently includes a non-expired record for `hostname`.

  Returns `true` when a valid (non-expired) entry exists and `false` otherwise.
  """
  def includes?(hostname) do
    # GenServer.call(@self, {:includes, hostname})
    GenServer.call(@self, {:includes, hostname}, 15_000)
  end

  @doc ~S"""
  Check whether `hostname` has ever been added to the cache, ignoring expiry.

  Returns `true` when the hostname exists in the cache map (even if expired) and
  `false` otherwise.
  """
  def includes?(hostname, :even_if_expired) do
    GenServer.call(@self, {:includes, hostname, :even_if_expired}, 15_000)
  end

  @doc ~S"""
  Remove any cached entry for `hostname`.
  """
  def delete(hostname) do
    # GenServer.call(@self, {:delete, hostname})
    GenServer.call(@self, {:delete, hostname}, 15_000)
  end

  @doc ~S"""
  Clear all cached entries and reset the cache to its initial state.
  """
  def flush do
    # GenServer.call(@self, {:flush})
    GenServer.call(@self, {:flush}, 15_000)
  end

  @doc ~S"""
  Dump all cached DNS records as a list.

  This is a convenience wrapper around `dump_cache/0` that returns only the
  `CloudflareApi.DnsRecord` structs instead of the internal entries.

  ## Examples

      iex> alias CloudflareApi.{Cache, DnsRecord}
      iex> Cache.flush()
      iex> record = %DnsRecord{zone_id: "zone", hostname: "www.example.com", ip: "1.2.3.4"}
      iex> Cache.add_or_update(record)
      iex> [cached] = Cache.dump()
      iex> {cached.zone_id, cached.hostname, cached.ip}
      {"zone", "www.example.com", "1.2.3.4"}
  """
  def dump do
    dump_cache()
    |> extract_hostnames()
  end

  @doc ~S"""
  Return the raw cache struct, including timestamps and internal state.
  """
  def dump_cache do
    # GenServer.call(@self, {:dump})
    GenServer.call(@self, {:dump}, 15_000)
  end

  @doc ~S"""
  Force a single hostname to be treated as expired.

  This keeps the cached entry (so `includes?/2` with `:even_if_expired` and
  `get/2` with `:even_if_expired` still work) but adjusts its timestamp so the
  regular cache lookups treat it as expired. Returns `:ok` even when the
  hostname is missing, making it safe to call in cleanup code.
  """
  def expire(hostname) do
    # GenServer.call(@self, {:expire, hostname})
    GenServer.call(@self, {:expire, hostname}, 15_000)
  end

  # Server

  @impl true
  def init(_init_arg) do
    # {:ok, %__MODULE__{expire_seconds: Application.get_env(:expire_seconds), hostnames: %{}}}
    {:ok, %__MODULE__{expire_seconds: 120, hostnames: %{}}}
  end

  @impl true
  def handle_call({:get, hostname}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :get hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    {:reply, get_entry_from_cache(cache, hostname), cache}
  end

  @impl true
  def handle_call({:get, hostname, :even_if_expired}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :get even_if_expired hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    {:reply, get_entry_from_cache(cache, hostname, :even_if_expired), cache}
  end

  @impl true
  def handle_call({:update, %DnsRecord{} = dns_record}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :update dns_record='#{Utils.to_string(dns_record)}', cache='#{Utils.to_string(cache)}"
    )

    {:reply, dns_record, add_entry(cache, to_entry(dns_record))}
  end

  @impl true
  def handle_call({:update, hostname, %DnsRecord{} = dns_record}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :update hostname='#{hostname}', dns_record='#{Utils.to_string(dns_record)}', cache='#{Utils.to_string(cache)}"
    )

    {:reply, dns_record, add_entry(cache, hostname, to_entry(dns_record))}
  end

  @impl true
  def handle_call({:includes, hostname}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :includes hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    case get_entry_from_cache(cache, hostname) do
      nil -> {:reply, false, cache}
      _ce -> {:reply, true, cache}
    end
  end

  @impl true
  def handle_call({:includes, hostname, :even_if_expired}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :includes hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    {:reply, Map.has_key?(cache.hostnames, hostname), cache}
  end

  @impl true
  def handle_call({:delete, hostname}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :delete hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    {:reply, :ok, remove_entry(cache, hostname)}
  end

  @impl true
  def handle_call({:flush}, _from, cache) do
    Logger.debug(__ENV__, "Handling call for :flush cache='#{Utils.to_string(cache)}'")

    {:reply, :ok, %__MODULE__{expire_seconds: 120, hostnames: %{}}}
  end

  @impl true
  def handle_call({:dump}, _from, cache) do
    Logger.debug(__ENV__, "Handling call for :dump cache='#{Utils.to_string(cache)}'")

    {:reply, cache, cache}
  end

  def handle_call({:expire, hostname}, _from, cache) do
    Logger.debug(
      __ENV__,
      "Handling call for :expire hostname='#{hostname}', cache='#{Utils.to_string(cache)}'"
    )

    {:reply, :ok, expire_entry(cache, hostname)}
  end

  defp cur_seconds() do
    System.monotonic_time(:second)
  end

  defp to_entry(%DnsRecord{} = dns_record) do
    %CacheEntry{timestamp: cur_seconds(), dns_record: dns_record}
  end

  @spec add_entry(cache :: Cache.t(), cache_entry :: CacheEntry.t()) :: Cache.t()
  defp add_entry(%Cache{} = cache, %CacheEntry{} = cache_entry) do
    cache
    |> Kernel.struct(
      hostnames: Map.put(cache.hostnames, cache_entry.dns_record.hostname, cache_entry)
    )
  end

  @spec add_entry(cache :: Cache.t(), hostname :: String.t(), cache_entry :: CacheEntry.t()) ::
          Cache.t()
  defp add_entry(%Cache{} = cache, hostname, %CacheEntry{} = cache_entry) do
    cache
    |> Kernel.struct(hostnames: Map.put(cache.hostnames, hostname, cache_entry))
  end

  defp get_entry_from_cache(%Cache{hostnames: _hostnames} = cache, hostname) do
    cache_entry = get_entry_from_cache(cache, hostname, :even_if_expired)

    cond do
      is_nil(cache_entry) -> nil
      expired?(cache_entry, cache.expire_seconds) -> nil
      true -> cache_entry
    end
  end

  defp get_entry_from_cache(%Cache{hostnames: hostnames} = _cache, hostname, :even_if_expired) do
    cond do
      Map.has_key?(hostnames, hostname) -> hostnames[hostname]
      true -> nil
    end
  end

  defp expired?(%Cache{} = cache, hostname) do
    case get_entry_from_cache(cache, hostname) do
      nil -> true
      cache_entry -> expired?(cache_entry, cache.expire_seconds)
    end
  end

  defp expired?(%CacheEntry{} = entry, expire_seconds) do
    entry.timestamp + expire_seconds < cur_seconds()
  end

  defp extract_hostnames(cache) do
    cache.hostnames
    |> Map.values()
    |> Enum.map(fn v -> v.dns_record end)
  end

  @spec remove_entry(cache :: Cache.t(), cache_entry :: CacheEntry.t()) :: Cache.t()
  defp remove_entry(%Cache{} = cache, %CacheEntry{} = cache_entry) do
    remove_entry(cache, cache_entry.dns_record.hostname)
  end

  @spec remove_entry(cache :: Cache.t(), hostname :: String.t()) :: Cache.t()
  defp remove_entry(%Cache{} = cache, hostname) do
    cache
    |> Kernel.struct(
      hostnames:
        Enum.reject(cache.hostnames, fn {hn, _dnsr} -> hn == hostname end)
        |> Enum.into(%{})
    )
  end

  @spec expire_entry(cache :: Cache.t(), hostname :: String.t()) :: Cache.t()
  defp expire_entry(%Cache{} = cache, hostname) when is_binary(hostname) do
    case Map.fetch(cache.hostnames, hostname) do
      {:ok, %CacheEntry{} = entry} ->
        Logger.debug(
          __ENV__,
          "Marking cache entry as expired hostname='#{hostname}', entry='#{Utils.to_string(entry)}'"
        )

        expired_entry = %CacheEntry{
          entry
          | timestamp: cur_seconds() - cache.expire_seconds - 1
        }

        cache
        |> Kernel.struct(hostnames: Map.put(cache.hostnames, hostname, expired_entry))

      :error ->
        Logger.debug(
          __ENV__,
          "No cache entry found to expire for hostname='#{hostname}'"
        )

        cache
    end
  end

  defp expire_entry(%Cache{} = cache, _hostname), do: cache
end
