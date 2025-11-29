defmodule CloudflareApi.Web3HostnameTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.Web3Hostname

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :list_hostnames,
      args: ["zone"],
      method: :get,
      path: "/zones/zone/web3/hostnames"
    },
    %{
      fun: :create_hostname,
      args: ["zone", %{"hostname" => "demo.com"}],
      method: :post,
      path: "/zones/zone/web3/hostnames",
      body: %{"hostname" => "demo.com"}
    },
    %{
      fun: :delete_hostname,
      args: ["zone", "host"],
      method: :delete,
      path: "/zones/zone/web3/hostnames/host"
    },
    %{
      fun: :get_hostname,
      args: ["zone", "host"],
      method: :get,
      path: "/zones/zone/web3/hostnames/host"
    },
    %{
      fun: :patch_hostname,
      args: ["zone", "host", %{"description" => "web3"}],
      method: :patch,
      path: "/zones/zone/web3/hostnames/host",
      body: %{"description" => "web3"}
    },
    %{
      fun: :get_content_list,
      args: ["zone", "host"],
      method: :get,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list"
    },
    %{
      fun: :update_content_list,
      args: ["zone", "host", %{"paths" => []}],
      method: :put,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list",
      body: %{"paths" => []}
    },
    %{
      fun: :list_content_list_entries,
      args: ["zone", "host"],
      method: :get,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list/entries"
    },
    %{
      fun: :create_content_list_entry,
      args: ["zone", "host", %{"pattern" => "/foo"}],
      method: :post,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list/entries",
      body: %{"pattern" => "/foo"}
    },
    %{
      fun: :delete_content_list_entry,
      args: ["zone", "host", "entry"],
      method: :delete,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list/entries/entry"
    },
    %{
      fun: :get_content_list_entry,
      args: ["zone", "host", "entry"],
      method: :get,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list/entries/entry"
    },
    %{
      fun: :update_content_list_entry,
      args: ["zone", "host", "entry", %{"pattern" => "/bar"}],
      method: :put,
      path: "/zones/zone/web3/hostnames/host/ipfs_universal_path/content_list/entries/entry",
      body: %{"pattern" => "/bar"}
    }
  ]

  for %{fun: fun, args: args, method: method, path: path} = entry <- @cases do
    body = Map.get(entry, :body, :no_body)

    test "#{fun} calls #{path}", %{client: client} do
      mock(fn %Tesla.Env{method: unquote(method), url: url} = env ->
        assert url == @base <> unquote(path)

        case unquote(Macro.escape(body)) do
          :no_body -> :ok
          expected -> assert Jason.decode!(env.body) == expected
        end

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
      end)

      assert {:ok, %{"ok" => true}} =
               apply(Web3Hostname, unquote(fun), [client | unquote(Macro.escape(args))])
    end
  end

  test "handles delete errors", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 500, body: %{"errors" => [%{"code" => 4000}]}}}
    end)

    assert {:error, [%{"code" => 4000}]} =
             Web3Hostname.delete_hostname(client, "zone", "host")
  end
end
