defmodule CloudflareApiTest do
  use ExUnit.Case, async: true

  doctest CloudflareApi

  test "new/1 returns a configured Tesla client" do
    token = "test-token"
    client = CloudflareApi.new(token)

    assert %Tesla.Client{pre: middleware} = client

    {Tesla.Middleware.BaseUrl, _fun, [base_url]} =
      Enum.find(middleware, fn {mod, _fun, _args} -> mod == Tesla.Middleware.BaseUrl end)

    assert base_url == "https://api.cloudflare.com/client/v4"

    assert Enum.any?(middleware, fn {mod, _fun, _args} -> mod == Tesla.Middleware.JSON end)

    assert Enum.any?(middleware, fn
             {Tesla.Middleware.BearerAuth, _fun, [opts]} ->
               Keyword.get(opts, :token) == token

             _ ->
               false
           end)
  end

  test "client/1 returns a reusable zero-arity function" do
    token = "another-token"

    client_fun = CloudflareApi.client(token)

    assert is_function(client_fun, 0)

    client1 = client_fun.()
    client2 = client_fun.()

    assert client1 == client2
    assert match?(%Tesla.Client{}, client1)
  end

  test "uri_encode_opts/1 encodes according to RFC3986" do
    opts = [{:name, "example domain"}, {:q, "a&b=c"}, {"weird", "value!"}]

    encoded = CloudflareApi.uri_encode_opts(opts)

    assert encoded =~ "name=example%20domain"
    assert encoded =~ "q=a%26b%3Dc"
    assert encoded =~ "weird=value%21"
  end
end
