defmodule FormbotApiTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts FormbotApi.Router.init([])

  test "return Unauthorized when basic auth failed" do
    conn = :get
      |> conn("/auth", "")
      |> FormbotApi.Router.call(@opts)
    assert conn.status == 401
  end
end
