defmodule FormbotApi.Plug.VerifyTokenTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use FormbotApi

  import Mock

  test "do nothing when not under path that needs verification" do
    conn = conn(:get, "/not-test", "") |> FormbotApi.Plug.VerifyToken.call(%{paths: ["/test"]})
    assert conn.status == nil
  end

  test "do nothing when valid token provided" do
    with_mock AuthTokenRepository, find_token: fn -> {:ok, "token"} end do
      conn = conn(:get, "/test", "")
        |> put_req_header("authorization", "token")
        |> FormbotApi.Plug.VerifyToken.call(%{paths: ["/test"]})
      assert conn.status == nil
    end
  end

  test "return 401 Forbidden when token NOT provided" do
    with_mock AuthTokenRepository, find_token: fn -> {:ok, "token"} end do
      conn = conn(:get, "/test", "") |> FormbotApi.Plug.VerifyToken.call(%{paths: ["/test"]})
      assert conn.status == 401
    end
  end
end
