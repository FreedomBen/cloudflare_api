defmodule CloudflareApi.CacheEntry do
  @moduledoc """
  use CloudflareApi.Typespecs

  Internal struct used by `CloudflareApi.Cache`.

  Each entry stores the cached `CloudflareApi.DnsRecord` along with the
  monotonic timestamp (in seconds) when it was inserted or last updated.
  """

  @enforce_keys [:timestamp, :dns_record]
  defstruct [:timestamp, :dns_record]

  @type t :: %__MODULE__{
          timestamp: integer(),
          dns_record: CloudflareApi.DnsRecord.t()
        }
end
