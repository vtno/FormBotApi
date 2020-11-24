defmodule FormbotApiTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import Mock

  @opts FormbotApi.Router.init([])

  describe "/auth" do
    test "return Unauthorized when basic auth failed" do
      conn =
        :get
        |> conn("/auth", "")
        |> FormbotApi.Router.call(@opts)

      assert conn.status == 401
    end

    test "return token when basic auth pass" do
      # Test basic auth: test:test
      mock_token = "token"

      with_mock FormbotApi.AuthTokenRepository, find_or_create_token: fn -> {:ok, mock_token} end do
        conn =
          :get
          |> conn("/auth", "")
          |> put_req_header("authorization", "Basic dGVzdDp0ZXN0")
          |> FormbotApi.Router.call(@opts)

        assert conn.status == 200
        assert conn.resp_body == mock_token
      end
    end
  end

  describe "/run-bot" do
    test "return 200 if no error" do
      with_mocks([
        {FormbotApi.AuthTokenRepository, [], [find_token: fn -> {:ok, "token"} end]},
        {System, [], [cmd: fn(_, _, _) -> end]}
      ]) do
        conn = conn(:get, "/run-bot", "")
          |> put_req_header("authorization", "token")
          |> FormbotApi.Router.call(@opts)
        assert conn.status == 200
      end
    end
  end
end
