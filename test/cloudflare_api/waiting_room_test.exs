defmodule CloudflareApi.WaitingRoomTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias CloudflareApi.WaitingRoom

  @base "https://api.cloudflare.com/client/v4"

  setup do
    {:ok, client: CloudflareApi.new("token")}
  end

  @cases [
    %{
      fun: :list_account_waiting_rooms,
      args: ["acc", [per_page: 10]],
      method: :get,
      path: "/accounts/acc/waiting_rooms?per_page=10"
    },
    %{
      fun: :list_zone_waiting_rooms,
      args: ["zone", [page: 2]],
      method: :get,
      path: "/zones/zone/waiting_rooms?page=2"
    },
    %{
      fun: :create_waiting_room,
      args: ["zone", %{"name" => "wr"}],
      method: :post,
      path: "/zones/zone/waiting_rooms",
      body: %{"name" => "wr"}
    },
    %{
      fun: :create_page_preview,
      args: ["zone", %{"body" => "<html>"}],
      method: :post,
      path: "/zones/zone/waiting_rooms/preview",
      body: %{"body" => "<html>"}
    },
    %{
      fun: :get_settings,
      args: ["zone"],
      method: :get,
      path: "/zones/zone/waiting_rooms/settings"
    },
    %{
      fun: :patch_settings,
      args: ["zone", %{"queueing_method" => "random"}],
      method: :patch,
      path: "/zones/zone/waiting_rooms/settings",
      body: %{"queueing_method" => "random"}
    },
    %{
      fun: :update_settings,
      args: ["zone", %{"queueing_method" => "fifo"}],
      method: :put,
      path: "/zones/zone/waiting_rooms/settings",
      body: %{"queueing_method" => "fifo"}
    },
    %{
      fun: :delete_waiting_room,
      args: ["zone", "wr"],
      method: :delete,
      path: "/zones/zone/waiting_rooms/wr"
    },
    %{
      fun: :get_waiting_room,
      args: ["zone", "wr"],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr"
    },
    %{
      fun: :patch_waiting_room,
      args: ["zone", "wr", %{"name" => "new"}],
      method: :patch,
      path: "/zones/zone/waiting_rooms/wr",
      body: %{"name" => "new"}
    },
    %{
      fun: :update_waiting_room,
      args: ["zone", "wr", %{"name" => "new"}],
      method: :put,
      path: "/zones/zone/waiting_rooms/wr",
      body: %{"name" => "new"}
    },
    %{
      fun: :list_events,
      args: ["zone", "wr", [per_page: 5]],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr/events?per_page=5"
    },
    %{
      fun: :create_event,
      args: ["zone", "wr", %{"name" => "sale"}],
      method: :post,
      path: "/zones/zone/waiting_rooms/wr/events",
      body: %{"name" => "sale"}
    },
    %{
      fun: :delete_event,
      args: ["zone", "wr", "evt"],
      method: :delete,
      path: "/zones/zone/waiting_rooms/wr/events/evt"
    },
    %{
      fun: :get_event,
      args: ["zone", "wr", "evt"],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr/events/evt"
    },
    %{
      fun: :patch_event,
      args: ["zone", "wr", "evt", %{"name" => "sale"}],
      method: :patch,
      path: "/zones/zone/waiting_rooms/wr/events/evt",
      body: %{"name" => "sale"}
    },
    %{
      fun: :update_event,
      args: ["zone", "wr", "evt", %{"name" => "sale"}],
      method: :put,
      path: "/zones/zone/waiting_rooms/wr/events/evt",
      body: %{"name" => "sale"}
    },
    %{
      fun: :preview_event_details,
      args: ["zone", "wr", "evt"],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr/events/evt/details"
    },
    %{
      fun: :list_rules,
      args: ["zone", "wr"],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr/rules"
    },
    %{
      fun: :create_rule,
      args: ["zone", "wr", %{"action" => "queue"}],
      method: :post,
      path: "/zones/zone/waiting_rooms/wr/rules",
      body: %{"action" => "queue"}
    },
    %{
      fun: :replace_rules,
      args: ["zone", "wr", %{"rules" => []}],
      method: :put,
      path: "/zones/zone/waiting_rooms/wr/rules",
      body: %{"rules" => []}
    },
    %{
      fun: :delete_rule,
      args: ["zone", "wr", "rule"],
      method: :delete,
      path: "/zones/zone/waiting_rooms/wr/rules/rule"
    },
    %{
      fun: :patch_rule,
      args: ["zone", "wr", "rule", %{"priority" => 1}],
      method: :patch,
      path: "/zones/zone/waiting_rooms/wr/rules/rule",
      body: %{"priority" => 1}
    },
    %{
      fun: :get_status,
      args: ["zone", "wr"],
      method: :get,
      path: "/zones/zone/waiting_rooms/wr/status"
    }
  ]

  for %{fun: fun, args: args, method: method, path: path} = entry <- @cases do
    body = Map.get(entry, :body, :no_body)

    test "#{fun} requests #{path}", %{client: client} do
      mock(fn %Tesla.Env{method: unquote(method), url: url} = env ->
        assert url == @base <> unquote(path)

        case unquote(Macro.escape(body)) do
          :no_body ->
            :ok

          expected ->
            assert Jason.decode!(env.body) == expected
        end

        {:ok, %Tesla.Env{env | status: 200, body: %{"result" => %{"ok" => true}}}}
      end)

      assert {:ok, %{"ok" => true}} =
               apply(WaitingRoom, unquote(fun), [client | unquote(Macro.escape(args))])
    end
  end

  test "returns errors from API", %{client: client} do
    mock(fn %Tesla.Env{} = env ->
      {:ok, %Tesla.Env{env | status: 400, body: %{"errors" => [%{"code" => 1000}]}}}
    end)

    assert {:error, [%{"code" => 1000}]} =
             WaitingRoom.create_waiting_room(client, "zone", %{"name" => "bad"})
  end
end
