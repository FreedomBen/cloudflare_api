ExUnit.start(exclude: [:skip], timeout: :infinity, capture_log: true)

Application.put_env(:tesla, :adapter, Tesla.Mock)
